//
// WorkoutRep.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app data models
//

import Foundation
import SwiftData

/// Represents a single repetition or set within a workout
@Model
class WorkoutRep {
    var id: UUID
    var repNumber: Int
    var distance: Double          // Distance in meters
    var duration: TimeInterval    // Duration in seconds
    var restTime: TimeInterval    // Rest time after this rep in seconds
    var pace: Double              // Calculated pace: seconds per kilometer

    init(repNumber: Int, distance: Double, duration: TimeInterval, restTime: TimeInterval = 0) {
        self.id = UUID()
        self.repNumber = repNumber
        self.distance = distance
        self.duration = duration
        self.restTime = restTime
        // Calculate pace: seconds per kilometer
        self.pace = distance > 0 ? (duration / (distance / 1000)) : 0
    }

    /// Formatted pace string (MM:SS per km)
    var formattedPace: String {
        let minutes = Int(pace) / 60
        let seconds = Int(pace) % 60
        return String(format: "%d:%02d/km", minutes, seconds)
    }

    /// Formatted duration string (MM:SS)
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
