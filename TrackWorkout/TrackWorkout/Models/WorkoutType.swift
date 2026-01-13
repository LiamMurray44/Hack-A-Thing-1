//
// WorkoutType.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app data models
//

import Foundation

/// Enum representing different types of running workouts
enum WorkoutType: String, Codable, CaseIterable {
    case sprint = "Sprint"
    case middleDistance = "Middle Distance"
    case longDistance = "Long Distance"
    case intervals = "Intervals"
    case tempo = "Tempo"
    case recovery = "Recovery"

    /// User-friendly display name
    var displayName: String {
        return self.rawValue
    }

    /// Description of the workout type
    var description: String {
        switch self {
        case .sprint:
            return "100m, 200m, 400m runs"
        case .middleDistance:
            return "800m, 1500m runs"
        case .longDistance:
            return "5K, 10K, and longer runs"
        case .intervals:
            return "Interval training sessions"
        case .tempo:
            return "Sustained tempo runs"
        case .recovery:
            return "Easy recovery runs"
        }
    }
}
