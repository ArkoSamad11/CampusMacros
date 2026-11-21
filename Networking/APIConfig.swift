//
//  APIConfig.swift
//  EXCHANGE PLACEHOLDER DATA WITH ACTUAL BACKEND HERE
//
import Foundation

enum APIConfig {
    /// true  -> use MockMenuService (no backend needed)
    /// false -> use LiveMenuService (real HTTP calls to `baseURL`)
    static let useMockData = true

    /// Where the backend lives. localhost works with the iOS Simulator if you run
    /// tools/mock_server.py. Replace with the deployed URL once backend is hosted.
    static let baseURL = URL(string: "http://localhost:8000")!
}

/// Shared service instance used by the view models. (Simple "dependency injection":
/// view models take a service in their init, defaulting to this one, so they're
/// easy to test with a fake.)
enum Services {
    static let menu: any MenuService = APIConfig.useMockData
        ? MockMenuService()
        : LiveMenuService(baseURL: APIConfig.baseURL)
}
