//
// TrackWorkoutTrackerApp.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app entry point
//

import SwiftUI
import SwiftData

@main
struct TrackWorkoutTrackerApp: App {
    // Configure SwiftData model container
    var modelContainer: ModelContainer = {
        let schema = Schema([
            Workout.self,
            WorkoutRep.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
