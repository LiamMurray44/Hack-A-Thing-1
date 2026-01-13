//
// Workout.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app data models
//

import Foundation
import SwiftData
import CoreLocation

/// Primary model representing a complete workout session
@Model
class Workout {
    var id: UUID
    var date: Date
    var workoutType: WorkoutType
    var title: String
    var notes: String?

    // Running-specific data
    var totalDistance: Double?        // Total distance in meters
    var totalDuration: TimeInterval   // Total duration in seconds
    var averagePace: Double?          // Average pace: seconds per kilometer
    @Relationship(deleteRule: .cascade) var repetitions: [WorkoutRep]

    // GPS tracking data
    var hasGPSData: Bool

    // Template relationship
    var isFromTemplate: Bool
    var templateID: UUID?

    // Live timer tracking
    var isLiveTracked: Bool
    var startedAt: Date?
    var completedAt: Date?

    // Metadata
    var createdAt: Date
    var updatedAt: Date

    init(date: Date, workoutType: WorkoutType, title: String) {
        self.id = UUID()
        self.date = date
        self.workoutType = workoutType
        self.title = title
        self.totalDuration = 0
        self.repetitions = []
        self.hasGPSData = false
        self.isFromTemplate = false
        self.isLiveTracked = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    /// Calculate total distance from all repetitions
    func calculateTotalDistance() {
        totalDistance = repetitions.reduce(0) { $0 + $1.distance }
    }

    /// Calculate total duration from all repetitions including rest times
    func calculateTotalDuration() {
        totalDuration = repetitions.reduce(0) { $0 + $1.duration + $1.restTime }
    }

    /// Calculate average pace from total distance and duration
    func calculateAveragePace() {
        if let distance = totalDistance, distance > 0 {
            averagePace = totalDuration / (distance / 1000)
        }
    }

    /// Update all calculated fields
    func updateCalculations() {
        calculateTotalDistance()
        calculateTotalDuration()
        calculateAveragePace()
        updatedAt = Date()
    }

    /// Formatted total distance (in km with 2 decimals)
    var formattedDistance: String {
        if let distance = totalDistance {
            return String(format: "%.2f km", distance / 1000)
        }
        return "N/A"
    }

    /// Formatted total duration (HH:MM:SS or MM:SS)
    var formattedDuration: String {
        let hours = Int(totalDuration) / 3600
        let minutes = (Int(totalDuration) % 3600) / 60
        let seconds = Int(totalDuration) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }

    /// Formatted average pace (MM:SS per km)
    var formattedAveragePace: String {
        if let pace = averagePace {
            let minutes = Int(pace) / 60
            let seconds = Int(pace) % 60
            return String(format: "%d:%02d/km", minutes, seconds)
        }
        return "N/A"
    }

    /// Formatted date string
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
