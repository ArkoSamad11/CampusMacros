//
//  DiningHall.swift
//  A dining hall plus the meal periods it serves.
//
import Foundation

struct DiningHall: Codable, Identifiable, Hashable {
    let id: String            // stable key, e.g. "okenshields"
    let name: String
    let location: String      // e.g. "Central Campus"
    let openNow: Bool
    let hoursSummary: String  // e.g. "11:00 AM - 2:00 PM"
}

enum MealPeriod: String, Codable, CaseIterable, Identifiable {
    case breakfast, lunch, dinner

    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}

/// Shape of the response from GET /v1/halls/{id}/menu
struct MenuResponse: Codable {
    let hallId: String
    let date: String          // "2026-11-21"
    let meal: MealPeriod
    let dishes: [Dish]
}
