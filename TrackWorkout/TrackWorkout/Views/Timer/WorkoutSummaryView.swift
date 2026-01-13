//
// WorkoutSummaryView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Add real-time timer feature to track workouts live
//

import SwiftUI
import SwiftData

struct WorkoutSummaryView: View {
    @Environment(WorkoutTimerService.self) private var timerService
    @Environment(\.modelContext) private var modelContext

    @State private var notes: String = ""
    @State private var showDiscardAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(timerService.workoutTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack {
                        Text(timerService.workoutType.displayName)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.blue)
                            .cornerRadius(8)

                        Spacer()

                        Text("Completed")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.green)
                            .cornerRadius(8)
                    }
                }

                // Summary stats
                HStack(spacing: 12) {
                    StatCard(
                        title: "Distance",
                        value: formattedDistance,
                        icon: "figure.run",
                        color: .blue
                    )

                    StatCard(
                        title: "Duration",
                        value: formattedDuration,
                        icon: "clock.fill",
                        color: .green
                    )

                    StatCard(
                        title: "Avg Pace",
                        value: formattedPace,
                        icon: "speedometer",
                        color: .orange
                    )
                }

                // Reps section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Repetitions (\(timerService.completedReps.count))")
                        .font(.title3)
                        .fontWeight(.semibold)

                    ForEach(timerService.completedReps, id: \.repNumber) { rep in
                        RepRowView(rep: rep)
                    }
                }
                .padding(.vertical, 8)

                // Notes section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notes")
                        .font(.title3)
                        .fontWeight(.semibold)

                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }

                // Action buttons
                VStack(spacing: 12) {
                    Button(action: saveWorkout) {
                        Text("SAVE WORKOUT")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(.green)
                            .cornerRadius(16)
                    }

                    Button(action: { showDiscardAlert = true }) {
                        Text("DISCARD")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .alert("Discard Workout?", isPresented: $showDiscardAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Discard", role: .destructive) {
                timerService.discardWorkout()
            }
        } message: {
            Text("This will permanently delete this workout. This action cannot be undone.")
        }
    }

    // MARK: - Computed Properties

    private var totalDistance: Double {
        timerService.completedReps.reduce(0) { $0 + $1.distance }
    }

    private var totalDuration: TimeInterval {
        timerService.completedReps.reduce(0) { $0 + $1.duration }
    }

    private var averagePace: Double? {
        guard totalDistance > 0 else { return nil }
        return totalDuration / (totalDistance / 1000)
    }

    private var formattedDistance: String {
        String(format: "%.2f km", totalDistance / 1000)
    }

    private var formattedDuration: String {
        let hours = Int(totalDuration) / 3600
        let minutes = (Int(totalDuration) % 3600) / 60
        let seconds = Int(totalDuration) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }

    private var formattedPace: String {
        if let pace = averagePace {
            let minutes = Int(pace) / 60
            let seconds = Int(pace) % 60
            return String(format: "%d:%02d/km", minutes, seconds)
        }
        return "N/A"
    }

    // MARK: - Actions

    private func saveWorkout() {
        // Create InProgressWorkout
        let inProgressWorkout = InProgressWorkout(
            workoutType: timerService.workoutType,
            title: timerService.workoutTitle,
            startTime: Date(),
            completedAt: Date(),
            completedReps: timerService.completedReps,
            notes: notes.isEmpty ? nil : notes
        )

        // Convert to Workout model
        let workout = inProgressWorkout.toWorkout(context: modelContext)

        // Insert into SwiftData
        modelContext.insert(workout)

        // Reset timer service
        timerService.resetWorkout()

        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RepRowView: View {
    let rep: CompletedRep

    var body: some View {
        HStack {
            // Rep number
            Text("Rep \(rep.repNumber)")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .leading)

            Spacer()

            // Distance
            VStack(alignment: .trailing, spacing: 2) {
                Text("Distance")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(String(format: "%.0f m", rep.distance))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            Spacer()

            // Duration
            VStack(alignment: .trailing, spacing: 2) {
                Text("Time")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(formatDuration(rep.duration))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            Spacer()

            // Pace
            VStack(alignment: .trailing, spacing: 2) {
                Text("Pace")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(formatPace(rep))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func formatPace(_ rep: CompletedRep) -> String {
        guard rep.distance > 0 else { return "N/A" }
        let pace = rep.duration / (rep.distance / 1000)
        let minutes = Int(pace) / 60
        let seconds = Int(pace) % 60
        return String(format: "%d:%02d/km", minutes, seconds)
    }
}

#Preview {
    WorkoutSummaryView()
        .environment(WorkoutTimerService())
        .modelContainer(for: [Workout.self, WorkoutRep.self], inMemory: true)
}
