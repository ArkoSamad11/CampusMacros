//
//  LiveMenuService.swift
//  Real networking with URLSession + async/await + Codable.
//
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case badStatus(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:        return "The server address is invalid."
        case .badStatus(let c):  return "The server returned an error (code \(c))."
        case .decoding:          return "We couldn't read the server's response."
        }
    }
}

struct LiveMenuService: MenuService {
    let baseURL: URL
    var session: URLSession = .shared

    func fetchHalls() async throws -> [DiningHall] {
        try await get("v1/halls")
    }

    func fetchMenu(hallID: String, meal: MealPeriod) async throws -> [Dish] {
        let response: MenuResponse = try await get(
            "v1/halls/\(hallID)/menu",
            query: [URLQueryItem(name: "meal", value: meal.rawValue)]
        )
        return response.dishes
    }

    // MARK: - Generic GET helper

    /// Builds the URL, performs the request, checks the status code, decodes JSON into `T`.
    private func get<T: Decodable>(_ path: String, query: [URLQueryItem] = []) async throws -> T {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else { throw APIError.invalidURL }

        if !query.isEmpty { components.queryItems = query }
        guard let url = components.url else { throw APIError.invalidURL }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        do {
            return try Self.makeDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    /// Backend uses snake_case keys; Swift uses camelCase.
    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
