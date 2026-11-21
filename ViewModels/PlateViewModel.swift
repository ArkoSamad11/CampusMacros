//
//  PlateViewModel.swift
//  The "tray" of dishes the user is considering. Shared across the whole app via
//  the SwiftUI environment (see CampusMacrosApp).
//
//  TODO (week 2): add `logPlate()` that saves the plate to a SwiftData food log.
//
import Foundation
import Observation
import SwiftUI

@Observable
@MainActor
final class PlateViewModel {
    private(set) var items: [PlateItem] = []

    /// Running macro total for everything on the plate.
    var totals: Macros {
        items.reduce(.zero) { $0 + $1.macros }
    }

    func add(_ dish: Dish, portion: Double) {
        items.append(PlateItem(dish: dish, portion: portion))
    }

    /// Used by SwiftUI's swipe-to-delete (`.onDelete`).
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func clear() {
        items.removeAll()
    }
}
