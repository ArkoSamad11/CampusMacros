//
//  DishRowView.swift
//  One row in a menu list: name, station, dietary tags, macro chips.
//
import SwiftUI

struct DishRowView: View {
    let dish: Dish

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(dish.name).font(.headline)

            Text("\(dish.station) · \(dish.servingDescription)")
                .font(.caption)
                .foregroundStyle(.secondary)

            MacroChipRow(macros: dish.macros)

            HStack(spacing: 6) {
                // Mark non-official numbers so users know they're estimates.
                if dish.isEstimate {
                    Text("est.").font(.caption2.italic()).foregroundStyle(.secondary)
                }
                ForEach(dish.dietaryTags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.15), in: Capsule())
                }
            }
        }
        .padding(.vertical, 4)
    }
}
