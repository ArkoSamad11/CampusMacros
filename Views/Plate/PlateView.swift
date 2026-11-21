//
//  PlateView.swift
//  Tab 3: the running plate. Shows what you've added, its macro total vs. goals,
//  and lets you remove items.
//
import SwiftUI

struct PlateView: View {
    @Environment(PlateViewModel.self) private var plate

    var body: some View {
        NavigationStack {
            Group {
                if plate.items.isEmpty {
                    ContentUnavailableView("Your plate is empty",
                                           systemImage: "fork.knife",
                                           description: Text("Add dishes from a menu to see your running macro total."))
                } else {
                    List {
                        Section("On your plate") {
                            ForEach(plate.items) { item in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(item.dish.name).font(.headline)
                                        Spacer()
                                        Text(portionLabel(item.portion)).foregroundStyle(.secondary)
                                    }
                                    MacroChipRow(macros: item.macros)
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: plate.remove(at:)) // swipe left to delete
                        }

                        Section {
                            GoalsSummaryCard(title: "Plate total vs. goals", consumed: plate.totals)
                                .listRowInsets(EdgeInsets())
                        }

                        Section {
                            Button("Log this plate") {
                                // TODO (week 2): save to the on-device food log, then clear.
                                plate.clear()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Plate")
        }
    }
}
