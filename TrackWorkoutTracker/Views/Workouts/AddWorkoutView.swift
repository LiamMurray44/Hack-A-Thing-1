//
// AddWorkoutView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Create iOS track and field workout tracking app manual entry form
//

import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var workoutDate = Date()
    @State private var selectedWorkoutType: WorkoutType = .sprint
    @State private var title = ""
    @State private var distance = ""
    @State private var duration = ""
    @State private var notes = ""
    @State private var numberOfReps = 1

    // Repetition data
    @State private var repDistances: [String] = [""]
    @State private var repDurations: [String] = [""]

    var body: some View {
        NavigationStack {
            Form {
                Section("Workout Details") {
                    DatePicker("Date", selection: $workoutDate, displayedComponents: [.date, .hourAndMinute])

                    Picker("Workout Type", selection: $selectedWorkoutType) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }

                    TextField("Workout Title", text: $title)
                        .autocorrectionDisabled()
                }

                Section("Repetitions") {
                    Stepper("Number of Reps: \(numberOfReps)", value: $numberOfReps, in: 1...20, onEditingChanged: { _ in
                        updateRepArrays()
                    })

                    ForEach(0..<numberOfReps, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rep \(index + 1)")
                                .font(.headline)

                            HStack {
                                Text("Distance (m):")
                                    .frame(width: 100, alignment: .leading)
                                TextField("400", text: Binding(
                                    get: { repDistances[safe: index] ?? "" },
                                    set: { repDistances[index] = $0 }
                                ))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                            }

                            HStack {
                                Text("Duration (sec):")
                                    .frame(width: 100, alignment: .leading)
                                TextField("60", text: Binding(
                                    get: { repDurations[safe: index] ?? "" },
                                    set: { repDurations[index] = $0 }
                                ))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }

    private var isFormValid: Bool {
        !title.isEmpty && repDistances.allSatisfy { !$0.isEmpty } && repDurations.allSatisfy { !$0.isEmpty }
    }

    private func updateRepArrays() {
        while repDistances.count < numberOfReps {
            repDistances.append("")
            repDurations.append("")
        }
        while repDistances.count > numberOfReps {
            repDistances.removeLast()
            repDurations.removeLast()
        }
    }

    private func saveWorkout() {
        let workout = Workout(date: workoutDate, workoutType: selectedWorkoutType, title: title)
        workout.notes = notes.isEmpty ? nil : notes

        // Create repetitions
        for i in 0..<numberOfReps {
            if let distance = Double(repDistances[i]),
               let duration = Double(repDurations[i]) {
                let rep = WorkoutRep(repNumber: i + 1, distance: distance, duration: duration)
                workout.repetitions.append(rep)
            }
        }

        // Calculate totals
        workout.updateCalculations()

        // Save to SwiftData
        modelContext.insert(workout)

        dismiss()
    }
}

// Safe array subscript extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    AddWorkoutView()
        .modelContainer(for: [Workout.self, WorkoutRep.self], inMemory: true)
}
