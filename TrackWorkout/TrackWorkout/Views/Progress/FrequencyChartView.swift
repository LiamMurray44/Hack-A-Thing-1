//
// FrequencyChartView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Build Progress Dashboard with charts to visualize workout statistics
//

import SwiftUI
import SwiftData
import Charts

struct FrequencyChartView: View {
    let workouts: [Workout]
    let period: TimePeriod

    var chartData: [WorkoutStats.FrequencyData] {
        WorkoutStats.workoutFrequency(from: workouts, groupBy: period)
    }

    var averageWorkoutsPerWeek: Double {
        let weeks = Double(period.daysBack) / 7.0
        return weeks > 0 ? Double(workouts.count) / weeks : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Workout Frequency")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            if chartData.isEmpty {
                Text("No frequency data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
            } else {
                Chart(chartData) { data in
                    BarMark(
                        x: .value("Period", data.periodStart),
                        y: .value("Count", data.workoutCount)
                    )
                    .foregroundStyle(.orange.gradient)
                }
                .frame(height: 180)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .padding(.horizontal)

                // Consistency metric
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.orange)
                    Text("Average: \(averageWorkoutsPerWeek, specifier: "%.1f") workouts/week")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .padding(.vertical)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    FrequencyChartView(workouts: [], period: .month)
        .modelContainer(for: [Workout.self], inMemory: true)
}
