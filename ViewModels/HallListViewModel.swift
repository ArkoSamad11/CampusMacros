//
//  HallListViewModel.swift
//  Loads the list of dining halls for the Menus tab.
//
import Foundation
import Observation

@Observable
@MainActor
final class HallListViewModel {
    private(set) var state: LoadState<[DiningHall]> = .idle
    private let service: any MenuService

    init(service: any MenuService = Services.menu) {
        self.service = service
    }

    /// `isRefresh` = pull-to-refresh: keep showing the old list instead of a spinner.
    func load(isRefresh: Bool = false) async {
        // Don't refetch when returning from a detail screen.
        if !isRefresh, case .loaded = state { return }
        if !isRefresh { state = .loading }

        do {
            state = .loaded(try await service.fetchHalls())
        } catch {
            if error.isCancellation { return }
            state = .failed(error.localizedDescription)
        }
    }
}
