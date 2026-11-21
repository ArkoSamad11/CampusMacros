//
//  MenuService.swift
//  The contract between the app and where menu data comes from (still need to figure this out.)
//
//  API CONTRACT (agree on this with backend):
//    GET /v1/halls                       -> [DiningHall]
//    GET /v1/halls/{id}/menu?meal=lunch  -> MenuResponse
//
import Foundation

protocol MenuService: Sendable {
    func fetchHalls() async throws -> [DiningHall]
    func fetchMenu(hallID: String, meal: MealPeriod) async throws -> [Dish]
}
