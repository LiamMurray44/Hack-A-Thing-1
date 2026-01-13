# TrackWorkout

A native iOS app for tracking track and field running workouts with real-time timer, progress analytics, and performance insights.

## Features

- **Live Timer Tracking** - Track workouts in real-time with lap splits and automatic pace calculation
- **Manual Workout Entry** - Log past workouts with multiple repetitions and distances
- **Progress Dashboard** - Visualize your progress with interactive charts:
  - Distance over time (bar chart)
  - Pace improvement trends (line chart)
  - Workout frequency (bar chart)
  - Personal records (best paces by workout type)
- **Workout Types** - Support for Sprint, Middle Distance, Long Distance, Intervals, Tempo, and Recovery runs
- **Home Dashboard** - Quick stats overview and recent workout preview

## Tech Stack

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Native data persistence (iOS 17+)
- **Swift Charts** - Interactive data visualizations
- **Combine** - Reactive timer implementation

## Requirements

- iOS 18.0+
- Xcode 15.0+
- macOS Sonoma or later

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Hack-A-Thing-1.git
   cd Hack-A-Thing-1
   ```

2. Open the project in Xcode:
   ```bash
   open TrackWorkout/TrackWorkout.xcodeproj
   ```

3. Select a simulator or connect your iPhone

4. Build and run (⌘R)

## Usage

1. **Start a Workout** - Tap the Timer tab and begin tracking with the live stopwatch
2. **Log Reps** - Hit the lap button after each repetition to record splits
3. **View Progress** - Check the Progress tab to see your performance trends
4. **Browse History** - Review all past workouts in the Workouts tab

## Project Structure

```
TrackWorkout/
├── Models/          # Data models (Workout, WorkoutRep, WorkoutType)
├── Views/           # SwiftUI views
│   ├── Home/       # Landing page
│   ├── Timer/      # Live workout tracking
│   ├── Workouts/   # Workout history and details
│   └── Progress/   # Charts and analytics
├── Services/        # Business logic (WorkoutTimerService)
└── Utilities/       # Helper functions and extensions
```

## Acknowledgments

Built for CS98 Hack-A-Thing #1 with assistance from Claude Code.
