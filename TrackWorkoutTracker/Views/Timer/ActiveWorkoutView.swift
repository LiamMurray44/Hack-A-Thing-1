//
// ActiveWorkoutView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Add real-time timer feature to track workouts live
//

import SwiftUI

struct ActiveWorkoutView: View {
    @Environment(WorkoutTimerService.self) private var timerService
    @State private var showRepSheet = false
    @State private var showStopAlert = false
    @State private var lapDuration: TimeInterval = 0

    var body: some View {
        VStack(spacing: 20) {
            // Header with workout info
            VStack(spacing: 8) {
                HStack {
                    Text(timerService.workoutTitle)
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    // Keep-awake indicator
                    Image(systemName: "wake")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }

                HStack {
                    Text(timerService.workoutType.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.blue)
                        .cornerRadius(8)

                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()

            // Rep indicator
            VStack(spacing: 4) {
                Text("Rep \(timerService.completedReps.count + 1)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            // Large timer display - current rep time
            Text(formatTime(timerService.currentRepElapsedTime))
                .font(.system(size: 72, design: .monospaced))
                .fontWeight(.bold)
                .foregroundStyle(timerService.state == .running ? .primary : .orange)

            // Total elapsed time (smaller)
            VStack(spacing: 4) {
                Text("Total Time")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(formatTime(timerService.totalElapsedTime))
                    .font(.title3)
                    .fontWeight(.medium)
                    .monospacedDigit()
            }

            Spacer()

            // Control buttons
            VStack(spacing: 16) {
                // Pause/Resume button (large)
                Button(action: togglePauseResume) {
                    HStack {
                        Image(systemName: timerService.state == .running ? "pause.fill" : "play.fill")
                            .font(.title2)
                        Text(timerService.state == .running ? "PAUSE" : "RESUME")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(timerService.state == .running ? .orange : .green)
                    .cornerRadius(16)
                }

                HStack(spacing: 12) {
                    // Lap button
                    Button(action: completeLap) {
                        HStack {
                            Image(systemName: "flag.checkered")
                            Text("LAP")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.blue)
                        .cornerRadius(12)
                    }
                    .disabled(timerService.state == .paused)
                    .opacity(timerService.state == .paused ? 0.5 : 1.0)

                    // Stop button
                    Button(action: { showStopAlert = true }) {
                        HStack {
                            Image(systemName: "stop.fill")
                            Text("STOP")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.red)
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showRepSheet) {
            RepCompletionSheet(duration: lapDuration)
        }
        .alert("Stop Workout?", isPresented: $showStopAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Stop", role: .destructive) {
                performHaptic()
                timerService.stopWorkout()
            }
        } message: {
            Text("Your workout will be saved with \(timerService.completedReps.count) completed rep(s).")
        }
    }

    private func togglePauseResume() {
        performHaptic()
        if timerService.state == .running {
            timerService.pauseWorkout()
        } else {
            timerService.resumeWorkout()
        }
    }

    private func completeLap() {
        performHaptic()
        lapDuration = timerService.completeLap()
        showRepSheet = true
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let tenths = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%d:%02d.%d", minutes, seconds, tenths)
    }

    private func performHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

#Preview {
    ActiveWorkoutView()
        .environment(WorkoutTimerService())
}
