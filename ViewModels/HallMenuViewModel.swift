//
//  HallMenuViewModel.swift
//  Loads one hall's menu for the selected meal, and handles sorting + dietary filters.
//
import Foundation
import Observation

enum SortOption: String, CaseIterable, Identifiable {
    case protein = "Most protein"
    case calories = "Fewest calories"
    case name = "Name"

    var id: String { rawValue }
}

@Observable
@MainActor
final class HallMenuViewModel {
    /// Tags the backend must send EXACTLY as spelled here. Only use official Cornell data for these.
    static let availableFilters = ["vegetarian", "vegan", "gluten-free"]

    let hall: DiningHall
    var selectedMeal: MealPeriod = .lunch   // TODO: default based on current time
    var sortOption: SortOption = .protein
    private(set) var activeFilters: Set<String> = []
    private(set) var state: LoadState<[Dish]> = .idle

    private let service: any MenuService
    private var loadedMeal: MealPeriod?

    init(hall: DiningHall, service: any MenuService = Services.menu) {
        self.hall = hall
        self.service = service
    }

    func load(isRefresh: Bool = false) async {
        let meal = selectedMeal
        // Skip if we already have this meal's menu (e.g. coming back from a dish screen).
        if !isRefresh, loadedMeal == meal, case .loaded = state { return }
        if !isRefresh { state = .loading }

        do {
            let dishes = try await service.fetchMenu(hallID: hall.id, meal: meal)
            state = .loaded(dishes)
            loadedMeal = meal
        } catch {
            if error.isCancellation { return }
            state = .failed(error.localizedDescription)
        }
    }

    func toggleFilter(_ tag: String) {
        if activeFilters.contains(tag) { activeFilters.remove(tag) } else { activeFilters.insert(tag) }
    }

    func isFilterActive(_ tag: String) -> Bool { activeFilters.contains(tag) }

    /// Applies the dietary filters, then the sort order, to the loaded dishes.
    func visibleDishes(from dishes: [Dish]) -> [Dish] {
        let filtered = dishes.filter { activeFilters.isSubset(of: Set($0.dietaryTags)) }
        switch sortOption {
        case .protein:  return filtered.sorted { $0.macros.protein > $1.macros.protein }
        case .calories: return filtered.sorted { $0.macros.calories < $1.macros.calories }
        case .name:     return filtered.sorted { $0.name < $1.name }
        }
    }
}
