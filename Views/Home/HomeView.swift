//
//  HomeView.swift
//  Tab 1: today's progress + dishes recommended for the user's remaining macros.
//  Uses a ScrollView (satisfies the "scrollable view" requirement).
//
import SwiftUI

struct HomeView: View {
    @Environment(PlateViewModel.self) private var plate
    @State private var viewModel = HomeViewModel()

    // Daily goals saved on-device from the Profile tab.
    @AppStorage(AppStorageKey.calorieGoal) private var calorieGoal = GoalDefaults.calories
    @AppStorage(AppStorageKey.proteinGoal) private var proteinGoal = GoalDefaults.protein
    @AppStorage(AppStorageKey.carbGoal) private var carbGoal = GoalDefaults.carbs
    @AppStorage(AppStorageKey.fatGoal) private var fatGoal = GoalDefaults.fat

    /// Goals minus whatever is currently on the plate.
    private var remaining: Macros {
        let eaten = plate.totals
        return Macros(calories: Double(calorieGoal) - eaten.calories,
                      protein: Double(proteinGoal) - eaten.protein,
                      carbs: Double(carbGoal) - eaten.carbs,
                      fat: Double(fatGoal) - eaten.fat)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    GoalsSummaryCard(title: "Today's plate vs. goals", consumed: plate.totals)

                    Text("Recommended for you")
                        .font(.title3.bold())

                    LoadStateView(state: viewModel.state, retry: { Task { await viewModel.load() } }) { dishes in
                        ForEach(Recommender.rank(dishes, remaining: remaining)) { dish in
                            NavigationLink(value: dish) {
                                RecommendationCard(dish: dish,
                                                   reason: Recommender.reason(for: dish, remaining: remaining))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationDestination(for: Dish.self) { DishDetailView(dish: $0) }
            .task { await viewModel.load() }
            .refreshable { await viewModel.load(isRefresh: true) }
        }
    }
}

/// One suggested dish: name, why it was suggested, and its macros.
private struct RecommendationCard: View {
    let dish: Dish
    let reason: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dish.name).font(.headline)
            Text(reason).font(.subheadline).foregroundStyle(.secondary)
            MacroChipRow(macros: dish.macros)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}
