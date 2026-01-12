# TrackWorkoutTracker - Setup Instructions

## Phase 1: Core Foundation Complete!

All the Swift code files for Phase 1 have been created. Now you need to create the Xcode project and add these files to it.

## Step 1: Create Xcode Project (2 minutes)

1. **Open Xcode** on your Mac

2. **Create New Project**:
   - Click "Create New Project" (or File > New > Project)
   - Select **iOS** tab at the top
   - Choose **App** template
   - Click **Next**

3. **Configure Project**:
   - **Product Name**: `TrackWorkoutTracker`
   - **Team**: Select your Apple ID
   - **Organization Identifier**: `com.yourname` (or whatever you prefer)
   - **Interface**: **SwiftUI** ⚠️ IMPORTANT
   - **Storage**: **SwiftData** ⚠️ IMPORTANT
   - **Language**: **Swift** ⚠️ IMPORTANT
   - **Include Tests**: You can check or uncheck (optional)
   - Click **Next**

4. **Save Location**:
   - Navigate to `/Users/liammurray/Hack-A-Thing-1/`
   - **IMPORTANT**: Uncheck "Create Git repository" (you already have one)
   - Click **Create**

## Step 2: Delete Default Files (1 minute)

Xcode creates some default files we don't need. In the Project Navigator (left sidebar):

1. **Right-click** on `ContentView.swift` (the default one) → **Delete** → Choose **"Move to Trash"**
2. **Right-click** on `Item.swift` (if it exists) → **Delete** → Choose **"Move to Trash"**
3. **Keep** `TrackWorkoutTrackerApp.swift` but we'll replace it

## Step 3: Add Your Code Files (5 minutes)

Now add the files I created:

### Method: Drag and Drop (Easiest)

1. **Open Finder** and navigate to:
   `/Users/liammurray/Hack-A-Thing-1/TrackWorkoutTracker/`

2. **In Xcode**, right-click on the `TrackWorkoutTracker` folder (the blue one at the top of the project navigator)

3. **For each folder** (Models, Views, Services, etc.):
   - **Drag the folder** from Finder into Xcode's project navigator
   - When the dialog appears:
     - ✅ Check "Copy items if needed"
     - ✅ Check "Create groups"
     - ✅ Make sure your target is selected
     - Click **Finish**

4. **Replace TrackWorkoutTrackerApp.swift**:
   - Delete the existing one Xcode created
   - Drag in the new one from the TrackWorkoutTracker folder

### File Structure Check

After adding files, your Xcode project should look like this:

```
TrackWorkoutTracker/
├── TrackWorkoutTrackerApp.swift
├── Models/
│   ├── WorkoutType.swift
│   ├── Workout.swift
│   └── WorkoutRep.swift
├── Views/
│   ├── ContentView.swift
│   └── Workouts/
│       ├── AddWorkoutView.swift
│       ├── WorkoutListView.swift
│       └── WorkoutDetailView.swift
└── Assets.xcassets
```

## Step 4: Build and Run (1 minute)

1. **Select a Simulator**:
   - At the top of Xcode, click the device dropdown (next to the Run button)
   - Choose any iPhone simulator (e.g., "iPhone 15 Pro")

2. **Build and Run**:
   - Press **Command + R** (or click the Play button)
   - Xcode will build the app
   - The iOS Simulator will launch with your app

3. **If you get errors**:
   - Make sure all files are added to the target (check the File Inspector)
   - Clean build folder: Product > Clean Build Folder
   - Try building again

## Step 5: Test the App

Once running, you should see:

1. **Empty State**: "No Workouts Yet" with a + button
2. **Tap the + button**: Opens the "Add Workout" form
3. **Fill out a workout**:
   - Choose a date
   - Select workout type (Sprint, Middle Distance, etc.)
   - Enter a title (e.g., "Morning 400m Repeats")
   - Set number of reps
   - Enter distance and duration for each rep
   - Add notes (optional)
   - Tap **Save**
4. **View Your Workout**: Should appear in the list
5. **Tap the Workout**: Opens detailed view showing all stats and reps

## Phase 1 Verification Checklist

- [ ] Can create new workout manually
- [ ] Workout saves to SwiftData
- [ ] Workouts appear in list sorted by date
- [ ] Tap workout shows detail view
- [ ] Dates and times display correctly
- [ ] Can delete workouts (swipe left on a workout)
- [ ] Stats calculate correctly (distance, duration, pace)

## What You've Built (Phase 1 Complete!)

You now have a working iOS app that can:
- ✅ Manually log workouts with multiple repetitions
- ✅ Track distance, duration, and pace for each rep
- ✅ View workout history in a list
- ✅ See detailed breakdown of each workout
- ✅ Store data persistently with SwiftData
- ✅ Delete workouts

## Next Steps (Phase 2: Timer)

Once you've tested Phase 1 and everything works, let me know and I can write the Phase 2 code which adds:
- Real-time timer during workouts
- Live tracking with lap button
- Start/stop/pause functionality
- Auto-calculated split times

## Troubleshooting

### Build Errors

**"Cannot find type 'Workout' in scope"**
- Make sure all Model files are added to the target
- Check: File Inspector > Target Membership checkbox

**"No such module 'SwiftData'"**
- Make sure minimum deployment target is iOS 17.0 or higher
- Check: Project Settings > General > Minimum Deployments

**Files not appearing in Xcode**
- Make sure you selected "Create groups" not "Create folder references"
- Try removing and re-adding the files

### Runtime Errors

**App crashes on launch**
- Check the Console output in Xcode (bottom panel)
- Look for SwiftData errors
- Make sure all models have @Model macro

**Workouts not saving**
- Check that modelContainer is attached to WindowGroup in TrackWorkoutTrackerApp.swift
- Verify modelContext is being used in AddWorkoutView

## Need Help?

If you run into any issues:
1. Check the Xcode Console output (View > Debug Area > Activate Console)
2. Look for red error messages
3. Let me know what error you're seeing

---

**Congratulations!** You've completed Phase 1 of your track and field workout tracker! 🎉
