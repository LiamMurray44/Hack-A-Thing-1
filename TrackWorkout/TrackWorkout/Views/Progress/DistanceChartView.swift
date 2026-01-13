//
// DistanceChartView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Build Progress Dashboard with charts to visualize workout statistics
//

import SwiftUI
import SwiftData
import Charts

struct DistanceChartView: View {
    let workouts: [Workout]
    let period: TimePeriod

    var chartData: [WorkoutStats.WeeklyDistance] {
        WorkoutStats.weeklyDistanceTotals(from: workouts)
    }

    var totalDistance: Double {
        chartData.reduce(0) { $0 + $1.totalDistance }
    }

    var averageDistance: Double {
        chartData.isEmpty ? 0 : totalDistance / Double(chartData.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Distance Over Time")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            if chartData.isEmpty {
                Text("No distance data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart(chartData) { data in
                    BarMark(
                        x: .value("Week", data.weekStartDate, unit: .weekOfYear),
                        y: .value("Distance", data.totalDistance / 1000)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let km = value.as(Double.self) {
                                Text("\(km, specifier: "%.0f") km")
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .padding(.horizontal)

                // Summary stats
                HStack(spacing: 12) {
                    StatCard(
                        icon: "sum",
                        title: "Total",
                        value: WorkoutStats.formatDistance(totalDistance),
                        color: .blue
                    )
                    StatCard(
                        icon: "chart.bar.fill",
                        title: "Average/Week",
                        value: WorkoutStats.formatDistance(averageDistance),
                        color: .green
                    )
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

#Preview {
    DistanceChartView(workouts: [], period: .month)
        .modelContainer(for: [Workout.self], inMemory: true)
}
