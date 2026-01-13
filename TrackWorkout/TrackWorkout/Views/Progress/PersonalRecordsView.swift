//
// PersonalRecordsView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Build Progress Dashboard with charts to visualize workout statistics
//

import SwiftUI

struct PersonalRecordsView: View {
    let workouts: [Workout]

    var records: [WorkoutStats.PersonalRecord] {
        WorkoutStats.personalRecords(from: workouts)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal Records")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            if records.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "trophy")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                    Text("Complete workouts to earn personal records!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(records) { record in
                        RecordCard(record: record)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct RecordCard: View {
    let record: WorkoutStats.PersonalRecord

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "trophy.fill")
                .font(.title)
                .foregroundColor(.yellow)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.workoutType.displayName)
                    .font(.headline)

                HStack {
                    Text("Best Pace:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(WorkoutStats.formatPace(record.bestPace))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Text(record.achievedDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    PersonalRecordsView(workouts: [])
        .modelContainer(for: [Workout.self], inMemory: true)
}
