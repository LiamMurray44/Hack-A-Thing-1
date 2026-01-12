//
// ContentView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app main navigation
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WorkoutListView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Workout.self, WorkoutRep.self], inMemory: true)
}
