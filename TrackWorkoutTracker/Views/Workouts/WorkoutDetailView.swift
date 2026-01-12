//
// WorkoutDetailView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app workout detail view
//

import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(workout.title)
                        .font(.title)
                        .fontWeight(.bold)

                    HStack {
                        Text(workout.workoutType.displayName)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)

                        Spacer()

                        Text(workout.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()

                // Summary Stats
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        StatCard(
                            icon: "ruler",
                            title: "Distance",
                            value: workout.formattedDistance,
                            color: .blue
                        )

                        StatCard(
                            icon: "clock",
                            title: "Duration",
                            value: workout.formattedDuration,
                            color: .green
                        )
                    }

                    if let pace = workout.averagePace {
                        StatCard(
                            icon: "gauge",
                            title: "Average Pace",
                            value: workout.formattedAveragePace,
                            color: .orange
                        )
                    }
                }
                .padding(.horizontal)

                // Repetitions Section
                if !workout.repetitions.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Repetitions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)

                        ForEach(workout.repetitions.sorted(by: { $0.repNumber < $1.repNumber }), id: \.id) { rep in
                            RepRowView(rep: rep)
                                .padding(.horizontal)
                        }
                    }
                }

                // Notes Section
                if let notes = workout.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(notes)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct RepRowView: View {
    let rep: WorkoutRep

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rep \(rep.repNumber)")
                .font(.headline)

            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.0f m", rep.distance))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }

                VStack(alignment: .leading) {
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(rep.formattedDuration)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }

                VStack(alignment: .leading) {
                    Text("Pace")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(rep.formattedPace)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationStack {
        let container = try! ModelContainer(for: Workout.self, WorkoutRep.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let workout = Workout(date: Date(), workoutType: .sprint, title: "Morning Sprint Session")
        workout.notes = "Felt great today!"
        let rep1 = WorkoutRep(repNumber: 1, distance: 400, duration: 65)
        let rep2 = WorkoutRep(repNumber: 2, distance: 400, duration: 63)
        workout.repetitions = [rep1, rep2]
        workout.updateCalculations()

        return WorkoutDetailView(workout: workout)
            .modelContainer(container)
    }
}
