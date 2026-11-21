//
//  Recommender.swift
//  Simple rule-based dish scoring (no ML needed). Improve later
//
import Foundation

enum Recommender {
    /// Highest-scoring dishes first.
    static func rank(_ dishes: [Dish], remaining: Macros) -> [Dish] {
        dishes.sorted { score($0, remaining: remaining) > score($1, remaining: remaining) }
    }

    /// Higher = better fit. Rewards protein per calorie, penalizes blowing the calorie budget.
    static func score(_ dish: Dish, remaining: Macros) -> Double {
        let proteinPerCalorie = dish.macros.protein / max(dish.macros.calories, 1)
        let caloriesOver = max(dish.macros.calories - remaining.calories, 0)
        return proteinPerCalorie * 100 - caloriesOver / 50
    }

    /// Short explanation shown on the recommendation card.
    static func reason(for dish: Dish, remaining: Macros) -> String {
        let protein = dish.macros.protein.rounded0
        if dish.macros.calories <= remaining.calories {
            return "\(protein)g protein · fits your remaining calorie budget"
        } else {
            return "\(protein)g protein · a bit over your remaining calories"
        }
    }
}
