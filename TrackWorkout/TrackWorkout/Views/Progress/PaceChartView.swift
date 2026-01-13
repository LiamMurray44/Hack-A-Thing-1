//
// PaceChartView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Build Progress Dashboard with charts to visualize workout statistics
//

import SwiftUI
import SwiftData
import Charts

struct PaceChartView: View {
    let workouts: [Workout]

    var chartData: [WorkoutStats.PaceDataPoint] {
        WorkoutStats.paceProgression(from: workouts)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pace Improvement")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            if chartData.isEmpty {
                Text("No pace data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart(chartData) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Pace", data.averagePace / 60) // Convert to minutes
                    )
                    .foregroundStyle(by: .value("Type", data.workoutType.displayName))
                    .symbol(by: .value("Type", data.workoutType.displayName))
                }
                .frame(height: 200)
                .chartYScale(domain: .automatic(includesZero: false))
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let mins = value.as(Double.self) {
                                Text("\(mins, specifier: "%.1f") min/km")
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .padding(.horizontal)

                // Best paces legend
                VStack(alignment: .leading, spacing: 8) {
                    Text("Best Paces by Type")
                        .font(.headline)

                    let typesWithData = Set(chartData.map { $0.workoutType })
                    ForEach(Array(typesWithData).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                        if let bestPace = chartData.filter({ $0.workoutType == type }).map({ $0.averagePace }).min() {
                            HStack {
                                Circle()
                                    .fill(colorForType(type))
                                    .frame(width: 10, height: 10)
                                Text("\(type.displayName):")
                                    .font(.caption)
                                Text(WorkoutStats.formatPace(bestPace))
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }
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

    private func colorForType(_ type: WorkoutType) -> Color {
        switch type {
        case .sprint: return .red
        case .middleDistance: return .orange
        case .longDistance: return .blue
        case .intervals: return .purple
        case .tempo: return .green
        case .recovery: return .gray
        }
    }
}

#Preview {
    PaceChartView(workouts: [])
        .modelContainer(for: [Workout.self], inMemory: true)
}
