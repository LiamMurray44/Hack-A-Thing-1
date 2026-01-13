//
// LiveWorkoutView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Add real-time timer feature to track workouts live
//

import SwiftUI

struct LiveWorkoutView: View {
    @Environment(WorkoutTimerService.self) private var timerService

    var body: some View {
        NavigationStack {
            Group {
                switch timerService.state {
                case .idle:
                    SetupView()
                case .running, .paused:
                    ActiveWorkoutView()
                case .completed:
                    WorkoutSummaryView()
                }
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Setup View

struct SetupView: View {
    @Environment(WorkoutTimerService.self) private var timerService
    @State private var selectedType: WorkoutType = .intervals
    @State private var workoutTitle: String = ""
    @State private var showRecoveryAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Stopwatch icon
            Image(systemName: "stopwatch.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .padding(.bottom, 20)

            Text("Start Tracking")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Setup form
            VStack(spacing: 20) {
                // Workout type picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Workout Type")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Picker("Workout Type", selection: $selectedType) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Title field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Workout Title")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    TextField("e.g., Morning Intervals", text: $workoutTitle)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            // Start button
            Button(action: startWorkout) {
                Text("START WORKOUT")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.green)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .disabled(workoutTitle.isEmpty)
            .opacity(workoutTitle.isEmpty ? 0.5 : 1.0)

            Spacer()
        }
        .padding()
        .onAppear {
            // Check if there's a paused workout to recover
            if timerService.state == .paused {
                showRecoveryAlert = true
            }
        }
        .alert("Resume Workout?", isPresented: $showRecoveryAlert) {
            Button("Resume") {
                // Timer service already has the paused workout
                // Just need to switch to ActiveWorkoutView
            }
            Button("Discard", role: .destructive) {
                timerService.discardWorkout()
            }
        } message: {
            Text("You have an unfinished workout from earlier. Would you like to resume it?")
        }
    }

    private func startWorkout() {
        let title = workoutTitle.isEmpty ? "\(selectedType.displayName) Workout" : workoutTitle
        timerService.startWorkout(type: selectedType, title: title)
    }
}

#Preview {
    LiveWorkoutView()
        .environment(WorkoutTimerService())
}
