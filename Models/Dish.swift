//
//  Dish.swift
//  A single menu item with ESTIMATED nutrition. Mirrors the JSON the backend sends.
//
//  The backend sends snake_case keys (e.g. "serving_description"); the decoder in
//  LiveMenuService converts them to camelCase automatically.
//
import Foundation

/// Where the nutrition numbers came from. We show this in the UI so users know
/// how much to trust a number.
enum NutritionSource: String, Codable, Hashable {
    case official   // matched to Cornell's NetNutrition data
    case usda       // matched to the USDA FoodData Central database
    case ai         // estimated by the LLM
    case manual     // hand-corrected by team

    /// If the backend sends a value we don't know yet, fall back to `.ai`
    /// instead of crashing the whole decode.
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = NutritionSource(rawValue: raw) ?? .ai
    }

    var label: String {
        switch self {
        case .official: return "Official Cornell data"
        case .usda:     return "Matched to USDA data"
        case .ai:       return "AI estimate"
        case .manual:   return "Manually verified"
        }
    }
}

struct Dish: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let station: String               // e.g. "Grill", "Salad Bar"
    let servingDescription: String    // e.g. "1 piece (~6 oz)"
    let dietaryTags: [String]         // e.g. ["vegetarian", "gluten-free"] (official data only!)
    let macros: Macros                // per 1x serving
    let confidence: Double            // 0.0 - 1.0
    let source: NutritionSource

    /// Anything not straight from Cornell is an estimate.
    var isEstimate: Bool { source != .official }

    var confidenceLabel: String {
        switch confidence {
        case 0.8...: return "High"
        case 0.5...: return "Medium"
        default:     return "Low"
        }
    }
}
