//
// RepCompletionSheet.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Add real-time timer feature to track workouts live
//

import SwiftUI

struct RepCompletionSheet: View {
    @Environment(WorkoutTimerService.self) private var timerService
    @Environment(\.dismiss) private var dismiss

    let duration: TimeInterval
    @State private var distanceText: String = ""
    @FocusState private var isDistanceFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // Checkered flag icon
                Image(systemName: "flag.checkered.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)

                // Rep number
                Text("Rep \(timerService.completedReps.count + 1) Complete!")
                    .font(.title)
                    .fontWeight(.bold)

                // Time display
                VStack(spacing: 4) {
                    Text("Time")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(formatTime(duration))
                        .font(.system(size: 48, design: .monospaced))
                        .fontWeight(.bold)
                }
                .padding(.vertical, 20)

                // Distance input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Distance (meters)")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    TextField("e.g., 400", text: $distanceText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .focused($isDistanceFocused)
                }
                .padding(.horizontal, 32)

                // Rest timer display
                VStack(spacing: 4) {
                    Text("Rest Timer")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(formatTime(timerService.currentRestElapsedTime))
                        .font(.title3)
                        .fontWeight(.medium)
                        .monospacedDigit()
                        .foregroundStyle(.orange)
                }
                .padding(.top, 8)

                Spacer()

                // Done button
                Button(action: completeRep) {
                    Text("DONE")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(distance > 0 ? .green : .gray)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .disabled(distance <= 0)
            }
            .padding()
            .navigationTitle("Lap Complete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        // Add rep with 0 distance
                        timerService.addCompletedRep(distance: 0, duration: duration)
                        dismiss()
                    }
                }
            }
            .onAppear {
                isDistanceFocused = true
            }
        }
        .presentationDetents([.medium])
    }

    private var distance: Double {
        Double(distanceText) ?? 0
    }

    private func completeRep() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        timerService.addCompletedRep(distance: distance, duration: duration)
        dismiss()
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    RepCompletionSheet(duration: 125.3)
        .environment(WorkoutTimerService())
}
