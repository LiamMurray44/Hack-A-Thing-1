//
// HomeView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create a nice home/landing page with workout imagery and quick stats
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.date, order: .reverse) private var allWorkouts: [Workout]
    @State private var selectedTab = 0

    var recentWorkouts: [Workout] {
        Array(allWorkouts.prefix(3))
    }

    var totalWorkouts: Int {
        allWorkouts.count
    }

    var totalDistance: Double {
        allWorkouts.compactMap { $0.totalDistance }.reduce(0, +)
    }

    var averagePace: Double? {
        let paces = allWorkouts.compactMap { $0.averagePace }
        guard !paces.isEmpty else { return nil }
        return paces.reduce(0, +) / Double(paces.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section
                    heroSection

                    // Quick Stats
                    quickStatsSection

                    // Quick Actions
                    quickActionsSection

                    // Recent Workouts
                    if !recentWorkouts.isEmpty {
                        recentWorkoutsSection
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 16) {
            // Gradient background with icon
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                .cornerRadius(20)

                VStack(spacing: 12) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 70))
                        .foregroundColor(.white)

                    Text("Track Your Progress")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Every run counts")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Quick Stats

    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Stats")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            if allWorkouts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No workouts yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Start your first workout to see your stats here")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            } else {
                HStack(spacing: 12) {
                    StatsCard(
                        icon: "number",
                        title: "Workouts",
                        value: "\(totalWorkouts)",
                        color: .blue
                    )

                    StatsCard(
                        icon: "ruler",
                        title: "Distance",
                        value: String(format: "%.1f km", totalDistance / 1000),
                        color: .green
                    )

                    if let pace = averagePace {
                        StatsCard(
                            icon: "gauge",
                            title: "Avg Pace",
                            value: formatPace(pace),
                            color: .orange
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Quick Actions

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            HStack(spacing: 12) {
                ActionButton(
                    icon: "stopwatch.fill",
                    title: "Start Workout",
                    subtitle: "Begin tracking",
                    color: .blue
                ) {
                    // Switch to Timer tab
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
                        if let tabBarController = findTabBarController(in: rootViewController) {
                            tabBarController.selectedIndex = 1 // Timer tab
                        }
                    }
                }

                ActionButton(
                    icon: "chart.xyaxis.line",
                    title: "View Progress",
                    subtitle: "See your stats",
                    color: .purple
                ) {
                    // Switch to Progress tab
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
                        if let tabBarController = findTabBarController(in: rootViewController) {
                            tabBarController.selectedIndex = 3 // Progress tab
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Recent Workouts

    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Workouts")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink(destination: WorkoutListView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(recentWorkouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        RecentWorkoutCard(workout: workout)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Helpers

    private func formatPace(_ secondsPerKm: Double) -> String {
        let minutes = Int(secondsPerKm) / 60
        let seconds = Int(secondsPerKm) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func findTabBarController(in viewController: UIViewController) -> UITabBarController? {
        if let tabBarController = viewController as? UITabBarController {
            return tabBarController
        }
        for child in viewController.children {
            if let result = findTabBarController(in: child) {
                return result
            }
        }
        return nil
    }
}

// MARK: - Stats Card Component

struct StatsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Action Button Component

struct ActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - Recent Workout Card Component

struct RecentWorkoutCard: View {
    let workout: Workout

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: iconForWorkoutType(workout.workoutType))
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(colorForWorkoutType(workout.workoutType))
                .cornerRadius(10)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    Label(workout.formattedDistance, systemImage: "ruler")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Label(workout.formattedDuration, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(workout.workoutType.displayName)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(colorForWorkoutType(workout.workoutType))
                    .cornerRadius(6)

                Text(workout.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func iconForWorkoutType(_ type: WorkoutType) -> String {
        switch type {
        case .sprint: return "bolt.fill"
        case .middleDistance: return "figure.run"
        case .longDistance: return "figure.walk"
        case .intervals: return "repeat"
        case .tempo: return "speedometer"
        case .recovery: return "leaf.fill"
        }
    }

    private func colorForWorkoutType(_ type: WorkoutType) -> Color {
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
    HomeView()
        .modelContainer(for: [Workout.self, WorkoutRep.self], inMemory: true)
}
