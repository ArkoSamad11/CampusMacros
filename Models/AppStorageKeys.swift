//
//  AppStorageKeys.swift
//  Keys + default values for settings saved on-device with @AppStorage (UserDefaults).
//
import Foundation

enum AppStorageKey {
    static let calorieGoal  = "calorieGoal"
    static let proteinGoal  = "proteinGoal"
    static let carbGoal     = "carbGoal"
    static let fatGoal      = "fatGoal"
    static let hideCalories = "hideCalories"
}

enum GoalDefaults {
    static let calories = 2000
    static let protein  = 150
    static let carbs    = 200
    static let fat      = 67
}
