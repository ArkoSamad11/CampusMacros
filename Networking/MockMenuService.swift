//
//  MockMenuService.swift
//  Fake backend so the iOS team can build before the real API exists.
//  Sleeps briefly to mimic network delay so loading spinners are visible.
//
//  NOTE: hall names and nutrition numbers are PLACEHOLDERS. Replace once real data exists.
//
import Foundation

struct MockMenuService: MenuService {
    var latency: Duration = .milliseconds(600)

    func fetchHalls() async throws -> [DiningHall] {
        try await Task.sleep(for: latency)
        return MockData.halls
    }

    func fetchMenu(hallID: String, meal: MealPeriod) async throws -> [Dish] {
        try await Task.sleep(for: latency)
        return meal == .breakfast ? MockData.breakfastDishes : MockData.mainDishes
    }
}

enum MockData {
    static let halls: [DiningHall] = [
        DiningHall(id: "morrison", name: "Morrison", location: "North Campus", openNow: true, hoursSummary: "11:00 AM - 8:00 PM"),
        DiningHall(id: "appel", name: "Appel", location: "North Campus", openNow: true, hoursSummary: "11:00 AM - 8:00 PM"),
        DiningHall(id: "risley", name: "Risley Dining Room", location: "North Campus", openNow: true, hoursSummary: "11:00 AM - 8:00 PM"),
        DiningHall(id: "okenshields", name: "Okenshields", location: "Central Campus", openNow: true, hoursSummary: "11:00 AM - 2:00 PM"),
        DiningHall(id: "becker", name: "Becker House", location: "West Campus", openNow: true, hoursSummary: "11:00 AM - 8:00 PM"),
        DiningHall(id: "bethe", name: "Bethe House", location: "West Campus", openNow: true, hoursSummary: "11:00 AM - 8:00 PM"),
        DiningHall(id: "cook", name: "Cook House", location: "West Campus", openNow: false, hoursSummary: "5:00 PM - 8:00 PM"),
        DiningHall(id: "keeton", name: "Keeton House", location: "West Campus", openNow: true, hoursSummary: "11:00 AM - 8:00 PM"),
        DiningHall(id: "rose", name: "Rose House", location: "West Campus", openNow: false, hoursSummary: "5:00 PM - 8:00 PM"),
    ]

    static let mainDishes: [Dish] = [
        Dish(id: "grilled_chicken", name: "Grilled Chicken Breast", station: "Grill", servingDescription: "1 piece (~5 oz)",
             dietaryTags: [], macros: Macros(calories: 280, protein: 42, carbs: 0, fat: 11), confidence: 0.85, source: .usda),
        Dish(id: "beef_chili", name: "Beef Chili", station: "Soup", servingDescription: "1 ladle (~8 oz)",
             dietaryTags: ["gluten-free"], macros: Macros(calories: 320, protein: 24, carbs: 28, fat: 12), confidence: 0.6, source: .ai),
        Dish(id: "cheese_pizza", name: "Cheese Pizza", station: "Pizza", servingDescription: "1 slice",
             dietaryTags: ["vegetarian"], macros: Macros(calories: 300, protein: 12, carbs: 36, fat: 12), confidence: 0.75, source: .usda),
        Dish(id: "tofu_stir_fry", name: "Tofu Vegetable Stir Fry", station: "Wok", servingDescription: "1 scoop (~6 oz)",
             dietaryTags: ["vegan", "vegetarian"], macros: Macros(calories: 260, protein: 16, carbs: 22, fat: 12), confidence: 0.55, source: .ai),
        Dish(id: "brown_rice", name: "Brown Rice", station: "Sides", servingDescription: "1 scoop (~1 cup)",
             dietaryTags: ["vegan", "vegetarian", "gluten-free"], macros: Macros(calories: 215, protein: 5, carbs: 45, fat: 2), confidence: 0.9, source: .official),
        Dish(id: "caesar_salad", name: "Caesar Salad", station: "Salad Bar", servingDescription: "1 bowl",
             dietaryTags: ["vegetarian"], macros: Macros(calories: 180, protein: 6, carbs: 9, fat: 14), confidence: 0.5, source: .ai),
        Dish(id: "roasted_broccoli", name: "Roasted Broccoli", station: "Sides", servingDescription: "1 scoop (~1/2 cup)",
             dietaryTags: ["vegan", "vegetarian", "gluten-free"], macros: Macros(calories: 90, protein: 4, carbs: 10, fat: 4), confidence: 0.8, source: .usda),
    ]

    static let breakfastDishes: [Dish] = [
        Dish(id: "scrambled_eggs", name: "Scrambled Eggs", station: "Hot Line", servingDescription: "1 scoop (~2 eggs)",
             dietaryTags: ["vegetarian", "gluten-free"], macros: Macros(calories: 200, protein: 14, carbs: 2, fat: 15), confidence: 0.8, source: .usda),
        Dish(id: "oatmeal", name: "Oatmeal", station: "Hot Line", servingDescription: "1 bowl",
             dietaryTags: ["vegan", "vegetarian"], macros: Macros(calories: 150, protein: 5, carbs: 27, fat: 3), confidence: 0.85, source: .official),
        Dish(id: "yogurt_parfait", name: "Greek Yogurt Parfait", station: "Cold Bar", servingDescription: "1 cup",
             dietaryTags: ["vegetarian"], macros: Macros(calories: 220, protein: 15, carbs: 30, fat: 5), confidence: 0.6, source: .ai),
        Dish(id: "blueberry_pancakes", name: "Blueberry Pancakes", station: "Griddle", servingDescription: "2 pancakes",
             dietaryTags: ["vegetarian"], macros: Macros(calories: 350, protein: 8, carbs: 60, fat: 9), confidence: 0.55, source: .ai),
    ]
}
