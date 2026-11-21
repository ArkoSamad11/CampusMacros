//
//  DishDetailView.swift
//  Shared detail screen (pushed from Home and Menus): portion picker, scaled macros,
//  estimate/confidence info, and "Add to plate".
//
import SwiftUI

struct DishDetailView: View {
    let dish: Dish

    @Environment(PlateViewModel.self) private var plate
    @Environment(\.dismiss) private var dismiss
    @State private var portion: Double = 1.0

    private let portionOptions: [Double] = [0.5, 1.0, 1.5, 2.0]

    private var scaledMacros: Macros { dish.macros.scaled(by: portion) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(dish.name).font(.title2.bold())
                    Text("\(dish.station) · 1× = \(dish.servingDescription)")
                        .foregroundStyle(.secondary)
                }

                // Portion selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Portion").font(.headline)
                    Picker("Portion", selection: $portion) {
                        ForEach(portionOptions, id: \.self) { Text(portionLabel($0)).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }

                // Macros for the chosen portion
                VStack(alignment: .leading, spacing: 8) {
                    Text(dish.isEstimate ? "Estimated nutrition" : "Nutrition").font(.headline)
                    MacroChipRow(macros: scaledMacros)
                }

                // Trust info
                VStack(alignment: .leading, spacing: 4) {
                    Label(dish.source.label, systemImage: dish.isEstimate ? "sparkles" : "checkmark.seal")
                    if dish.isEstimate {
                        Text("Confidence: \(dish.confidenceLabel). Actual values may vary with how the dish is prepared and served.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    // TODO: show a calorie RANGE instead of a single number.
                }
                .font(.subheadline)

                // Dietary tags (official Cornell data only).
                if !dish.dietaryTags.isEmpty {
                    Text("Dietary: " + dish.dietaryTags.joined(separator: ", "))
                        .font(.subheadline)
                    Text("Always confirm allergens with dining staff.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Dish")
        .navigationBarTitleDisplayMode(.inline)
        // Pinned button at the bottom of the screen.
        .safeAreaInset(edge: .bottom) {
            Button {
                plate.add(dish, portion: portion)
                dismiss()
            } label: {
                Text("Add \(portionLabel(portion)) to plate")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
            }
            .padding()
            .background(.bar)
        }
    }
}
