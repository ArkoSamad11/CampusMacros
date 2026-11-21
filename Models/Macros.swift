//
//  Macros.swift
//  Calories + macronutrients. Used for a dish, a plate, or a daily goal.
//
import Foundation

struct Macros: Codable, Hashable {
    var calories: Double
    var protein: Double   // grams
    var carbs: Double     // grams
    var fat: Double       // grams

    static let zero = Macros(calories: 0, protein: 0, carbs: 0, fat: 0)

    /// Add two Macros together (used to total up a plate).
    static func + (lhs: Macros, rhs: Macros) -> Macros {
        Macros(calories: lhs.calories + rhs.calories,
               protein: lhs.protein + rhs.protein,
               carbs: lhs.carbs + rhs.carbs,
               fat: lhs.fat + rhs.fat)
    }

    /// Multiply everything by a portion factor (0.5x, 1x, 2x...).
    func scaled(by factor: Double) -> Macros {
        Macros(calories: calories * factor,
               protein: protein * factor,
               carbs: carbs * factor,
               fat: fat * factor)
    }
}
