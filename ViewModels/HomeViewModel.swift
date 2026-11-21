//
//  HomeViewModel.swift
//  Loads candidate dishes for the Home tab's recommendations.
//
import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    private(set) var state: LoadState<[Dish]> = .idle
    private let service: any MenuService

    init(service: any MenuService = Services.menu) {
        self.service = service
    }

    func load(isRefresh: Bool = false) async {
        if !isRefresh, case .loaded = state { return }
        if !isRefresh { state = .loading }

        do {
            let halls = try await service.fetchHalls()
            // TODO: fetch ALL open halls and pick the meal based on the current time.
            // For now: first open hall, lunch.
            guard let hall = halls.first(where: \.openNow) ?? halls.first else {
                state = .loaded([])
                return
            }
            state = .loaded(try await service.fetchMenu(hallID: hall.id, meal: .lunch))
        } catch {
            if error.isCancellation { return }
            state = .failed(error.localizedDescription)
        }
    }
}
