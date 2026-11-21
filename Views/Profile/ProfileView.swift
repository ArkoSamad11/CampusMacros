//
//  ProfileView.swift
//  Tab 4: daily goals + display preferences, saved on-device with @AppStorage.
//  Changing a value here instantly updates every screen that reads the same key.
//
import SwiftUI

struct ProfileView: View {
    @AppStorage(AppStorageKey.calorieGoal) private var calorieGoal = GoalDefaults.calories
    @AppStorage(AppStorageKey.proteinGoal) private var proteinGoal = GoalDefaults.protein
    @AppStorage(AppStorageKey.carbGoal) private var carbGoal = GoalDefaults.carbs
    @AppStorage(AppStorageKey.fatGoal) private var fatGoal = GoalDefaults.fat
    @AppStorage(AppStorageKey.hideCalories) private var hideCalories = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Quick presets") {
                    Button("High protein") { applyPreset(calories: 2200, protein: 160, carbs: 220, fat: 65) }
                    Button("Balanced") { applyPreset(calories: 2200, protein: 120, carbs: 270, fat: 70) }
                }

                Section("Daily goals") {
                    Stepper("Protein: \(proteinGoal) g", value: $proteinGoal, in: 20...400, step: 5)
                    Stepper("Carbs: \(carbGoal) g", value: $carbGoal, in: 20...600, step: 5)
                    Stepper("Fat: \(fatGoal) g", value: $fatGoal, in: 10...250, step: 5)
                    Stepper("Calories: \(calorieGoal) kcal", value: $calorieGoal, in: 1000...5000, step: 50)
                }

                Section {
                    Toggle("Hide calories", isOn: $hideCalories)
                } header: {
                    Text("Display")
                } footer: {
                    Text("Show only protein, carbs, and fat throughout the app.")
                }

                Section {
                    Text("Nutrition values for dining hall dishes are estimates. Goals are starting points, not medical advice.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profile")
        }
    }

    private func applyPreset(calories: Int, protein: Int, carbs: Int, fat: Int) {
        calorieGoal = calories
        proteinGoal = protein
        carbGoal = carbs
        fatGoal = fat
    }
}
