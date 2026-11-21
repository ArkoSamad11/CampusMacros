//
//  PlateItem.swift
//  One dish the user has added to their plate, with a chosen portion size.
//
import Foundation

struct PlateItem: Identifiable {
    let id = UUID()
    let dish: Dish
    var portion: Double          // 0.5, 1.0, 1.5, 2.0 ...

    /// Macros after applying the portion multiplier.
    var macros: Macros { dish.macros.scaled(by: portion) }
}
