//
// ProgressView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Build Progress Dashboard with charts to visualize workout statistics
//

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.date, order: .reverse) private var allWorkouts: [Workout]
    @State private var selectedPeriod: TimePeriod = .month

    var filteredWorkouts: [Workout] {
        let cutoffDate = Calendar.current.date(
            byAdding: .day,
            value: -selectedPeriod.daysBack,
            to: Date()
        ) ?? Date()
        return allWorkouts.filter { $0.date >= cutoffDate }
    }

    var body: some View {
        NavigationStack {
            Group {
                if allWorkouts.isEmpty {
                    ContentUnavailableView(
                        "No Workout Data",
                        systemImage: "chart.xyaxis.line",
                        description: Text("Complete some workouts to see your progress charts")
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Period picker
                            Picker("Time Period", selection: $selectedPeriod) {
                                ForEach(TimePeriod.allCases, id: \.self) { period in
                                    Text(period.rawValue).tag(period)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)

                            // Charts
                            DistanceChartView(workouts: filteredWorkouts, period: selectedPeriod)
                            PaceChartView(workouts: filteredWorkouts)
                            FrequencyChartView(workouts: filteredWorkouts, period: selectedPeriod)
                            PersonalRecordsView(workouts: allWorkouts)
                        }
                        .padding(.vertical)
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedPeriod)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProgressView()
        .modelContainer(for: [Workout.self, WorkoutRep.self], inMemory: true)
}
