//
//  HallMenuView.swift
//  Tab 2, screen 2: one hall's menu with meal picker, sorting, and dietary filters.
//
import SwiftUI

struct HallMenuView: View {
    // `@State` + a custom init lets us build the view model with the hall passed in.
    @State private var viewModel: HallMenuViewModel

    init(hall: DiningHall) {
        _viewModel = State(initialValue: HallMenuViewModel(hall: hall))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Breakfast / Lunch / Dinner switcher
            Picker("Meal", selection: $viewModel.selectedMeal) {
                ForEach(MealPeriod.allCases) { meal in
                    Text(meal.displayName).tag(meal)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            LoadStateView(state: viewModel.state, retry: { Task { await viewModel.load() } }) { dishes in
                let visible = viewModel.visibleDishes(from: dishes)
                if visible.isEmpty {
                    ContentUnavailableView("No dishes match", systemImage: "line.3.horizontal.decrease.circle",
                                           description: Text("Try removing a dietary filter."))
                } else {
                    List(visible) { dish in
                        NavigationLink(value: dish) { DishRowView(dish: dish) }
                    }
                    .listStyle(.plain)
                    .refreshable { await viewModel.load(isRefresh: true) }
                }
            }
        }
        .navigationTitle(viewModel.hall.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Dish.self) { DishDetailView(dish: $0) }
        // `task(id:)` re-runs whenever the selected meal changes (and cancels the old request).
        .task(id: viewModel.selectedMeal) { await viewModel.load() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Sort by", selection: $viewModel.sortOption) {
                        ForEach(SortOption.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Section("Dietary") {
                        ForEach(HallMenuViewModel.availableFilters, id: \.self) { tag in
                            Button {
                                viewModel.toggleFilter(tag)
                            } label: {
                                if viewModel.isFilterActive(tag) {
                                    Label(tag.capitalized, systemImage: "checkmark")
                                } else {
                                    Text(tag.capitalized)
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
}
