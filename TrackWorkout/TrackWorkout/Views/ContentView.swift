//
// ContentView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app main navigation
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            LiveWorkoutView()
                .tabItem {
                    Label("Timer", systemImage: "stopwatch")
                }

            WorkoutListView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.xyaxis.line")
                }

            MotivationalQuotesView()
                .tabItem {
                    Label("Motivation", systemImage: "quote.bubble")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Workout.self, WorkoutRep.self], inMemory: true)
}
