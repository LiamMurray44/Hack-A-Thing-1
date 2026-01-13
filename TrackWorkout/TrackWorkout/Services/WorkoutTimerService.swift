//
// WorkoutTimerService.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Add real-time timer feature to track workouts live
//

import Foundation
import SwiftUI
import Combine
import UIKit

/// Timer state machine for workout lifecycle
enum TimerState {
    case idle           // No workout in progress
    case running        // Timer actively counting
    case paused         // Timer stopped but workout not finished
    case completed      // Workout finished, ready to save
}

/// Completed rep data during active workout
struct CompletedRep: Codable {
    var repNumber: Int
    var distance: Double
    var duration: TimeInterval
    var restStartTime: Date?
}

/// Service managing timer state and workout tracking
@Observable
class WorkoutTimerService {
    // MARK: - Published State
    var state: TimerState = .idle
    var workoutType: WorkoutType = .intervals
    var workoutTitle: String = ""
    var completedReps: [CompletedRep] = []

    // Current rep timing
    var currentRepStartTime: Date?
    var totalElapsedTime: TimeInterval = 0
    var currentRepElapsedTime: TimeInterval = 0

    // Rest timer
    var currentRestStartTime: Date?
    var currentRestElapsedTime: TimeInterval = 0

    // MARK: - Private Properties
    private var timer: AnyCancellable?
    private var workoutStartTime: Date?
    private var pausedTime: Date?
    private var totalPausedDuration: TimeInterval = 0

    // UserDefaults keys for persistence
    private let inProgressWorkoutKey = "inProgressWorkout"
    private let workoutStateKey = "workoutState"

    // MARK: - Initialization
    init() {
        setupBackgroundObservers()
        checkForAbandonedWorkout()
    }

    deinit {
        stopTimer()
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public Methods

    /// Start a new workout
    func startWorkout(type: WorkoutType, title: String) {
        workoutType = type
        workoutTitle = title
        workoutStartTime = Date()
        currentRepStartTime = Date()
        completedReps = []
        totalPausedDuration = 0
        state = .running

        startTimer()
        enableKeepAwake()
        saveWorkoutState()
    }

    /// Pause the active workout
    func pauseWorkout() {
        guard state == .running else { return }

        state = .paused
        pausedTime = Date()
        stopTimer()
        saveWorkoutState()
    }

    /// Resume paused workout
    func resumeWorkout() {
        guard state == .paused, let pausedTime = pausedTime else { return }

        // Add paused duration to total
        totalPausedDuration += Date().timeIntervalSince(pausedTime)
        self.pausedTime = nil

        state = .running
        startTimer()
        saveWorkoutState()
    }

    /// Complete current lap/rep
    func completeLap() -> TimeInterval {
        guard state == .running || state == .paused,
              let repStartTime = currentRepStartTime else {
            return 0
        }

        let duration = Date().timeIntervalSince(repStartTime) -
                      (pausedTime != nil ? Date().timeIntervalSince(pausedTime!) : 0)

        return duration
    }

    /// Add completed rep after user enters distance
    func addCompletedRep(distance: Double, duration: TimeInterval) {
        let repNumber = completedReps.count + 1
        let rep = CompletedRep(
            repNumber: repNumber,
            distance: distance,
            duration: duration,
            restStartTime: Date()
        )

        completedReps.append(rep)

        // Start next rep
        currentRepStartTime = Date()
        currentRestStartTime = Date()

        saveWorkoutState()
    }

    /// Stop workout and move to summary
    func stopWorkout() {
        state = .completed
        stopTimer()
        disableKeepAwake()
        saveWorkoutState()
    }

    /// Discard workout and reset
    func discardWorkout() {
        resetWorkout()
        clearWorkoutState()
    }

    /// Reset service to idle state
    func resetWorkout() {
        state = .idle
        workoutTitle = ""
        workoutType = .intervals
        completedReps = []
        currentRepStartTime = nil
        workoutStartTime = nil
        pausedTime = nil
        totalPausedDuration = 0
        totalElapsedTime = 0
        currentRepElapsedTime = 0
        currentRestStartTime = nil
        currentRestElapsedTime = 0

        stopTimer()
        disableKeepAwake()
    }

    /// Get total workout duration
    func getTotalDuration() -> TimeInterval {
        guard let startTime = workoutStartTime else { return 0 }

        let elapsed = Date().timeIntervalSince(startTime) - totalPausedDuration

        if state == .paused, let pausedTime = pausedTime {
            return elapsed - Date().timeIntervalSince(pausedTime)
        }

        return elapsed
    }

    // MARK: - Timer Management

    private func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateElapsedTime()
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func updateElapsedTime() {
        guard state == .running else { return }

        // Update total elapsed time
        if let startTime = workoutStartTime {
            totalElapsedTime = Date().timeIntervalSince(startTime) - totalPausedDuration
        }

        // Update current rep elapsed time
        if let repStartTime = currentRepStartTime {
            currentRepElapsedTime = Date().timeIntervalSince(repStartTime)
        }

        // Update rest elapsed time
        if let restStartTime = currentRestStartTime {
            currentRestElapsedTime = Date().timeIntervalSince(restStartTime)
        }
    }

    // MARK: - Keep Awake Management

    private func enableKeepAwake() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }

    private func disableKeepAwake() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    // MARK: - Background Handling

    private func setupBackgroundObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc private func appDidEnterBackground() {
        if state == .running {
            pauseWorkout()
        }
        saveWorkoutState()
    }

    @objc private func appWillEnterForeground() {
        // Workout remains paused - user must manually resume
    }

    // MARK: - Persistence

    private func saveWorkoutState() {
        guard state != .idle else {
            clearWorkoutState()
            return
        }

        let workoutData: [String: Any] = [
            "workoutType": workoutType.rawValue,
            "workoutTitle": workoutTitle,
            "completedReps": (try? JSONEncoder().encode(completedReps)) as Any,
            "state": stateString(state),
            "workoutStartTime": workoutStartTime as Any,
            "currentRepStartTime": currentRepStartTime as Any,
            "totalPausedDuration": totalPausedDuration,
            "pausedTime": pausedTime as Any
        ]

        UserDefaults.standard.set(workoutData, forKey: inProgressWorkoutKey)
        UserDefaults.standard.set(Date(), forKey: workoutStateKey)
    }

    private func clearWorkoutState() {
        UserDefaults.standard.removeObject(forKey: inProgressWorkoutKey)
        UserDefaults.standard.removeObject(forKey: workoutStateKey)
    }

    private func checkForAbandonedWorkout() {
        guard let savedDate = UserDefaults.standard.object(forKey: workoutStateKey) as? Date,
              let workoutData = UserDefaults.standard.dictionary(forKey: inProgressWorkoutKey),
              Date().timeIntervalSince(savedDate) < 24 * 60 * 60 else {
            // No saved workout or too old (> 24 hours)
            clearWorkoutState()
            return
        }

        // Restore workout data
        if let typeString = workoutData["workoutType"] as? String,
           let type = WorkoutType(rawValue: typeString) {
            workoutType = type
        }

        workoutTitle = workoutData["workoutTitle"] as? String ?? ""
        workoutStartTime = workoutData["workoutStartTime"] as? Date
        currentRepStartTime = workoutData["currentRepStartTime"] as? Date
        totalPausedDuration = workoutData["totalPausedDuration"] as? TimeInterval ?? 0
        pausedTime = workoutData["pausedTime"] as? Date

        if let repsData = workoutData["completedReps"] as? Data {
            completedReps = (try? JSONDecoder().decode([CompletedRep].self, from: repsData)) ?? []
        }

        // Restore to paused state for user review
        state = .paused
    }

    private func stateString(_ state: TimerState) -> String {
        switch state {
        case .idle: return "idle"
        case .running: return "running"
        case .paused: return "paused"
        case .completed: return "completed"
        }
    }
}
