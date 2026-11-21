//
//  MacroChip.swift
//  Small rounded "pill" showing one number, plus a row that shows all macros.
//
import SwiftUI

struct MacroChip: View {
    let title: String
    let value: String
    var tint: Color = .accentColor

    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.subheadline.bold())
            Text(title).font(.caption2).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
    }
}

/// Protein first (it's what most users care about), then carbs, fat, and optionally calories.
struct MacroChipRow: View {
    let macros: Macros
    // Respects the "Hide calories" toggle from the Profile tab.
    @AppStorage(AppStorageKey.hideCalories) private var hideCalories = false

    var body: some View {
        HStack(spacing: 8) {
            MacroChip(title: "Protein", value: "\(macros.protein.rounded0)g", tint: .blue)
            MacroChip(title: "Carbs", value: "\(macros.carbs.rounded0)g", tint: .orange)
            MacroChip(title: "Fat", value: "\(macros.fat.rounded0)g", tint: .pink)
            if !hideCalories {
                MacroChip(title: "kcal", value: macros.calories.rounded0, tint: .gray)
            }
        }
    }
}
