# 🚀 TrackWorkoutTracker - Complete Setup Guide

## Phase 1: Core Foundation Complete!

All the Swift code files for Phase 1 have been created. Now you need to create the Xcode project and add these files to it.

---

## STEP 1: Create the Xcode Project Shell (2 minutes)

### 1.1 Open Xcode
- Find and open the **Xcode** app on your Mac

### 1.2 Start a New Project
You'll see a welcome screen. Click the big **"Create New Project"** button.

(Or if Xcode is already open: **File** menu → **New** → **Project**)

### 1.3 Choose the Template
- At the top, make sure **iOS** is selected (not macOS, watchOS, etc.)
- Click on **App** (it has a phone icon)
- Click **Next** button (bottom right)

### 1.4 Fill Out the Project Settings
You'll see a form. Fill it out EXACTLY like this:

| Field | What to Enter | Why It Matters |
|-------|---------------|----------------|
| **Product Name** | `TrackWorkoutTracker` | Must match exactly |
| **Team** | Select your Apple ID | For running on devices |
| **Organization Identifier** | `com.yourname` | Any unique ID works |
| **Interface** | **SwiftUI** | ⚠️ CRITICAL - Must be SwiftUI! |
| **Storage** | **SwiftData** | ⚠️ CRITICAL - Must be SwiftData! |
| **Language** | **Swift** | ⚠️ CRITICAL - Must be Swift! |
| **Include Tests** | Check or uncheck | Doesn't matter for now |

Click **Next**

### 1.5 Choose Where to Save
- Navigate to: `/Users/liammurray/Hack-A-Thing-1/`
- **IMPORTANT**: ❌ **Uncheck** "Create Git repository" (you already have one)
- Click **Create**

Xcode will now create the project and open it.

---

## STEP 2: Clean Up Default Files (1 minute)

Xcode created some sample files we don't need. Let's delete them.

### Look at the Left Sidebar (Project Navigator)
You'll see a folder structure. Find these files:

### 2.1 Delete ContentView.swift
- **Right-click** on `ContentView.swift`
- Choose **Delete**
- In the popup, click **"Move to Trash"** (not "Remove Reference")

### 2.2 Delete Item.swift (if it exists)
- **Right-click** on `Item.swift` (might not exist, that's OK)
- Choose **Delete**
- Click **"Move to Trash"**

### 2.3 Keep TrackWorkoutTrackerApp.swift
- We'll replace this file in the next step, but don't delete it yet

---

## STEP 3: Add My Code Files (5 minutes)

Now we'll add the Swift files I wrote for you.

### 3.1 Open Finder Side-by-Side
- Open **Finder**
- Navigate to: `/Users/liammurray/Hack-A-Thing-1/TrackWorkoutTracker/`
- You should see folders: `Models`, `Views`, `Services`, etc.

**Tip**: Arrange your windows so you can see both Finder and Xcode at the same time (split screen)

### 3.2 Drag the Folders Into Xcode

In **Xcode's left sidebar**, find the blue folder icon called `TrackWorkoutTracker` (at the top).

Now, **one by one**, drag these folders from Finder into Xcode:

#### A. Drag the **Models** folder
- **Drag** the `Models` folder from Finder onto the `TrackWorkoutTracker` folder in Xcode
- A dialog box will appear with checkboxes:
  - ✅ **Check** "Copy items if needed"
  - ✅ **Check** "Create groups" (should be selected by default)
  - ✅ Make sure `TrackWorkoutTracker` target is checked
  - Click **Finish**

#### B. Drag the **Views** folder
- Same process: drag `Views` folder into Xcode
- Same checkboxes: ✅ Copy items, ✅ Create groups
- Click **Finish**

#### C. Drag the **Services** folder
- Same process (even though it's empty for now)

#### D. Drag the **Utilities** folder
- Same process

### 3.3 Replace TrackWorkoutTrackerApp.swift
- In Xcode, **delete** the existing `TrackWorkoutTrackerApp.swift` (the one Xcode created)
- From Finder, **drag** the NEW `TrackWorkoutTrackerApp.swift` (from the TrackWorkoutTracker folder) into Xcode
- Same checkboxes: ✅ Copy items, ✅ Create groups
- Click **Finish**

### 3.4 Verify Your File Structure
Your Xcode project navigator (left sidebar) should now look like this:

```
TrackWorkoutTracker (blue folder)
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
├── Services/
├── Utilities/
└── Assets.xcassets
```

---

## STEP 4: Build and Run (1 minute)

Time to see your app in action!

### 4.1 Select a Simulator
At the **very top of Xcode** (in the toolbar), you'll see a device dropdown next to a Play button.

- Click that dropdown
- Choose any iPhone (e.g., **iPhone 15 Pro**)

### 4.2 Run the App
- Press **Command + R** on your keyboard

  OR

- Click the **▶ Play button** at the top left

### 4.3 Wait for Build
- Xcode will compile your code (takes 10-30 seconds first time)
- The iOS Simulator will launch (a fake iPhone on your screen)
- Your app will appear!

### 4.4 If You Get Errors
Don't panic! Try this:
1. **Clean the build**: Menu bar → **Product** → **Clean Build Folder**
2. Try running again (Command + R)
3. If still errors, check the Troubleshooting section below

---

## STEP 5: Test Your App

### What You Should See

#### First Screen: Empty State
- You'll see text: **"No Workouts Yet"**
- A runner icon
- A **+ button** in the top right corner

#### Click the + Button
- A form appears titled **"Add Workout"**

#### Fill Out a Sample Workout
Try this example:
1. **Date**: Keep today's date
2. **Workout Type**: Select **Sprint**
3. **Workout Title**: Type `Morning 400m Repeats`
4. **Number of Reps**: Increase to **3** (using the stepper)
5. **Rep 1**:
   - Distance: `400`
   - Duration: `65`
6. **Rep 2**:
   - Distance: `400`
   - Duration: `63`
7. **Rep 3**:
   - Distance: `400`
   - Duration: `64`
8. **Notes**: `Felt great today!`
9. Click **Save** (top right)

#### Back to List
- Your workout appears in the list!
- Shows distance, time, and pace

#### Tap the Workout
- Opens a detailed view
- Shows all 3 reps
- Shows stats and pace for each rep
- Shows your notes

#### Try More Features
- Swipe left on a workout → **Delete** button appears
- Add more workouts with different types
- View them all in the list

---

## ✅ Success Checklist

Your app is working if you can:
- [ ] Create a new workout with multiple reps
- [ ] See it saved in the list
- [ ] Tap it to see full details
- [ ] See calculated pace for each rep
- [ ] Swipe left to delete workouts
- [ ] Add notes to workouts
- [ ] See different workout types

---

## 🎉 What You've Built (Phase 1 Complete!)

If everything works, you now have a real iOS app with:
- ✅ Manual workout logging with multiple repetitions
- ✅ Distance, duration, and pace tracking
- ✅ Workout history sorted by date
- ✅ Detailed workout view with rep breakdown
- ✅ Persistent data storage with SwiftData
- ✅ Delete functionality
- ✅ Beautiful SwiftUI interface
- ✅ Notes for each workout

This is a **fully functional app** you can actually use!

---

## 🚀 What's Next? (Phase 2: Timer)

Once Phase 1 is working and tested, let me know and I'll write **Phase 2** code which adds:
- ⏱️ **Real-time timer** for live workouts
- 🏃 **Track as you run** with automatic timing
- ⏸️ **Start/Stop/Pause** buttons
- 📊 **Automatic lap splits** for each rep
- 🎯 **Live pace calculations** while running

---

## ⚠️ Troubleshooting

### Common Build Errors

#### Error: "Cannot find type 'Workout' in scope"
**Cause**: Files aren't added to the build target

**Fix**:
1. Click on any Swift file (like `Workout.swift`) in the Project Navigator
2. Look at the **right sidebar** (if not visible: View → Inspectors → Show File Inspector)
3. Find the **Target Membership** section
4. Make sure `TrackWorkoutTracker` checkbox is checked
5. Repeat for all Swift files showing errors

#### Error: "No such module 'SwiftData'"
**Cause**: Deployment target is too old

**Fix**:
1. Click on the **blue project icon** at the top of the Project Navigator
2. Select **TrackWorkoutTracker** under TARGETS
3. Click **General** tab
4. Find **Minimum Deployments**
5. Change iOS version to **17.0** or higher

#### Error: "Multiple commands produce..."
**Cause**: Duplicate files in the project

**Fix**:
1. Check if you have duplicate `ContentView.swift` or `TrackWorkoutTrackerApp.swift` files
2. Delete duplicates (keep only one of each)
3. Clean build folder: Product → Clean Build Folder
4. Build again

#### Files not appearing in Xcode
**Cause**: Wrong import method

**Fix**:
1. Remove the files/folders from Xcode
2. Re-drag them from Finder
3. This time make sure to select **"Create groups"** NOT "Create folder references"
4. Groups show as yellow folders, references show as blue folders

### Common Runtime Errors

#### App crashes immediately on launch
**Symptoms**: Simulator opens but app crashes right away

**Fix**:
1. Look at the **Console** at the bottom of Xcode (View → Debug Area → Activate Console)
2. Look for error messages mentioning SwiftData or models
3. Common causes:
   - Models missing @Model macro (check `Workout.swift` and `WorkoutRep.swift`)
   - ModelContainer not configured correctly in `TrackWorkoutTrackerApp.swift`

#### Workouts not saving / disappearing after restart
**Symptoms**: Can create workouts but they don't persist

**Fix**:
1. Make sure `modelContainer` is attached to `WindowGroup` in `TrackWorkoutTrackerApp.swift`
2. Check that views are using `@Environment(\.modelContext)` correctly
3. Verify `modelContext.insert(workout)` is called in `AddWorkoutView.swift:saveWorkout()`

#### Simulator won't launch
**Symptoms**: Build succeeds but simulator doesn't open

**Fix**:
1. Make sure you selected a **simulator device** (not "Any iOS Device")
2. Try a different simulator: Click device dropdown → select different iPhone
3. Restart Xcode if needed

#### Build takes forever (spinning wheel)
**Symptoms**: Build never completes

**Fix**:
1. First build can take 1-2 minutes (be patient!)
2. If it's been > 3 minutes: Stop (Command + .)
3. Clean build: Product → Clean Build Folder
4. Build again (Command + R)

---

## 💡 Tips & Tricks

### Xcode Shortcuts
- **Command + R**: Run/Build the app
- **Command + .**: Stop running app
- **Command + B**: Build without running
- **Command + Shift + K**: Clean build folder

### SwiftUI Previews
Each Swift file has a `#Preview` at the bottom. You can see live previews:
1. Open any View file (like `AddWorkoutView.swift`)
2. Look for the **Canvas** on the right side
3. If not visible: Editor → Canvas
4. Click **Resume** button to see live preview
5. Previews update as you edit code!

### Debugging
- Add `print("Debug message")` anywhere in your code
- Run the app
- Messages appear in the Console (bottom of Xcode)
- Example: `print("Saving workout: \(workout.title)")`

---

## 📱 Testing on a Real iPhone (Optional)

Want to run on your actual iPhone?

1. **Connect your iPhone** to your Mac with a cable
2. **Select your iPhone** from the device dropdown (it will appear when connected)
3. **Trust your Mac** (popup on iPhone if first time)
4. **Run the app** (Command + R)
5. If you get a signing error:
   - Go to Project Settings → Signing & Capabilities
   - Check "Automatically manage signing"
   - Select your Team (Apple ID)

GPS tracking (Phase 4) requires a real device!

---

## 📚 Learning Resources

As you work with the code:
- [Apple's SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui) - Official beginner guide
- [Hacking with Swift](https://www.hackingwithswift.com/100/swiftui) - Free 100 Days course
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata) - Learn about data persistence

---

## 🆘 Still Stuck?

If you're still having issues:
1. **Check the Console**: View → Debug Area → Activate Console
2. **Read error messages** carefully (they usually tell you what's wrong)
3. **Take a screenshot** of any errors
4. **Let me know** what error you're seeing and I'll help!

---

## 🎊 Congratulations!

Once you see your first workout in the app, you've officially built your first iOS app! This is a **real, functional application** with data persistence, multiple screens, and calculations.

**You're now an iOS developer!** 🚀

Ready for Phase 2 when you are!
