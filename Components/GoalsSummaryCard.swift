//
//  GoalsSummaryCard.swift
//  Progress bars comparing what's on the plate to the user's daily goals.
//  Reads goals straight from @AppStorage, so it updates when the Profile changes.
//
//  TODO (week 2): pass in "eaten today (logged) + current plate" instead of just the plate.
//
import SwiftUI

struct GoalsSummaryCard: View {
    let title: String
    let consumed: Macros

    @AppStorage(AppStorageKey.calorieGoal) private var calorieGoal = GoalDefaults.calories
    @AppStorage(AppStorageKey.proteinGoal) private var proteinGoal = GoalDefaults.protein
    @AppStorage(AppStorageKey.carbGoal) private var carbGoal = GoalDefaults.carbs
    @AppStorage(AppStorageKey.fatGoal) private var fatGoal = GoalDefaults.fat
    @AppStorage(AppStorageKey.hideCalories) private var hideCalories = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)

            // Protein first, calories optional.
            MacroProgressRow(label: "Protein", consumed: consumed.protein, goal: Double(proteinGoal), unit: "g", tint: .blue)
            MacroProgressRow(label: "Carbs", consumed: consumed.carbs, goal: Double(carbGoal), unit: "g", tint: .orange)
            MacroProgressRow(label: "Fat", consumed: consumed.fat, goal: Double(fatGoal), unit: "g", tint: .pink)
            if !hideCalories {
                MacroProgressRow(label: "Calories", consumed: consumed.calories, goal: Double(calorieGoal), unit: "kcal", tint: .gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct MacroProgressRow: View {
    let label: String
    let consumed: Double
    let goal: Double
    let unit: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label).font(.subheadline)
                Spacer()
                Text("\(consumed.rounded0) / \(goal.rounded0) \(unit)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: min(consumed, goal), total: max(goal, 1))
                .tint(tint)
        }
    }
}
