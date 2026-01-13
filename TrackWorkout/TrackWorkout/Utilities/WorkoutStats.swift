//
// WorkoutStats.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Build Progress Dashboard with charts to visualize workout statistics
//

import Foundation

/// Time period options for filtering workout data
enum TimePeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case threeMonths = "3 Months"
    case year = "Year"

    var daysBack: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .threeMonths: return 90
        case .year: return 365
        }
    }
}

/// Utility for aggregating workout data into chart-friendly structures
struct WorkoutStats {

    // MARK: - Data Structures

    struct WeeklyDistance: Identifiable {
        let id = UUID()
        let weekStartDate: Date
        let totalDistance: Double // in meters
    }

    struct PaceDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let averagePace: Double // seconds per km
        let workoutType: WorkoutType
    }

    struct FrequencyData: Identifiable {
        let id = UUID()
        let periodStart: Date
        let workoutCount: Int
    }

    struct PersonalRecord: Identifiable {
        let id = UUID()
        let workoutType: WorkoutType
        let distance: Double
        let bestPace: Double
        let achievedDate: Date
    }

    // MARK: - Aggregation Methods

    /// Calculate total distance for each week
    static func weeklyDistanceTotals(from workouts: [Workout]) -> [WeeklyDistance] {
        let calendar = Calendar.current

        // Group by week
        let grouped = Dictionary(grouping: workouts) { workout in
            calendar.dateInterval(of: .weekOfYear, for: workout.date)?.start ?? workout.date
        }

        // Calculate totals
        return grouped.map { weekStart, weekWorkouts in
            let total = weekWorkouts.compactMap { $0.totalDistance }.reduce(0, +)
            return WeeklyDistance(weekStartDate: weekStart, totalDistance: total)
        }
        .sorted { $0.weekStartDate < $1.weekStartDate }
    }

    /// Extract pace progression over time by workout type
    static func paceProgression(from workouts: [Workout]) -> [PaceDataPoint] {
        return workouts
            .filter { $0.averagePace != nil && $0.averagePace! > 0 }
            .map { workout in
                PaceDataPoint(
                    date: workout.date,
                    averagePace: workout.averagePace!,
                    workoutType: workout.workoutType
                )
            }
            .sorted { $0.date < $1.date }
    }

    /// Count workouts grouped by time period
    static func workoutFrequency(from workouts: [Workout], groupBy period: TimePeriod) -> [FrequencyData] {
        let calendar = Calendar.current
        let component: Calendar.Component = period == .week ? .weekOfYear : .month

        let grouped = Dictionary(grouping: workouts) { workout in
            calendar.dateInterval(of: component, for: workout.date)?.start ?? workout.date
        }

        return grouped.map { periodStart, periodWorkouts in
            FrequencyData(periodStart: periodStart, workoutCount: periodWorkouts.count)
        }
        .sorted { $0.periodStart < $1.periodStart }
    }

    /// Find best pace for each workout type
    static func personalRecords(from workouts: [Workout]) -> [PersonalRecord] {
        var records: [WorkoutType: (pace: Double, distance: Double, date: Date)] = [:]

        for workout in workouts {
            guard let pace = workout.averagePace, pace > 0,
                  let distance = workout.totalDistance, distance > 0 else { continue }

            if let existing = records[workout.workoutType] {
                // Lower pace is better
                if pace < existing.pace {
                    records[workout.workoutType] = (pace, distance, workout.date)
                }
            } else {
                records[workout.workoutType] = (pace, distance, workout.date)
            }
        }

        return records.map { type, data in
            PersonalRecord(
                workoutType: type,
                distance: data.distance,
                bestPace: data.pace,
                achievedDate: data.date
            )
        }
        .sorted { $0.workoutType.rawValue < $1.workoutType.rawValue }
    }

    // MARK: - Formatting Helpers

    static func formatDistance(_ meters: Double) -> String {
        String(format: "%.2f km", meters / 1000)
    }

    static func formatPace(_ secondsPerKm: Double) -> String {
        let minutes = Int(secondsPerKm) / 60
        let seconds = Int(secondsPerKm) % 60
        return String(format: "%d:%02d/km", minutes, seconds)
    }
}
