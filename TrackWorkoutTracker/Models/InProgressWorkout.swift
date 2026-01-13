//
// InProgressWorkout.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Add real-time timer feature to track workouts live
//

import Foundation
import SwiftData

/// Temporary data structure for workouts being actively tracked
struct InProgressWorkout {
    var workoutType: WorkoutType
    var title: String
    var startTime: Date
    var completedAt: Date?
    var completedReps: [CompletedRep]
    var notes: String?

    /// Convert in-progress workout to persistent Workout model
    func toWorkout(context: ModelContext) -> Workout {
        let workout = Workout(
            date: startTime,
            workoutType: workoutType,
            title: title
        )

        // Set timer-specific fields
        workout.isLiveTracked = true
        workout.startedAt = startTime
        workout.completedAt = completedAt ?? Date()
        workout.notes = notes

        // Convert completed reps to WorkoutRep models
        for completedRep in completedReps {
            let rep = WorkoutRep(
                repNumber: completedRep.repNumber,
                distance: completedRep.distance,
                duration: completedRep.duration
            )
            workout.repetitions.append(rep)
        }

        // Calculate all fields
        workout.updateCalculations()

        return workout
    }

    /// Calculate total distance from all reps
    var totalDistance: Double {
        completedReps.reduce(0) { $0 + $1.distance }
    }

    /// Calculate total duration from all reps
    var totalDuration: TimeInterval {
        completedReps.reduce(0) { $0 + $1.duration }
    }

    /// Calculate average pace
    var averagePace: Double? {
        guard totalDistance > 0 else { return nil }
        return totalDuration / (totalDistance / 1000)
    }

    /// Formatted total distance (in km with 2 decimals)
    var formattedDistance: String {
        String(format: "%.2f km", totalDistance / 1000)
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
}
