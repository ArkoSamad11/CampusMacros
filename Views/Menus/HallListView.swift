//
//  HallListView.swift
//  Tab 2, screen 1: list of dining halls. Tap one to push its menu.
//
import SwiftUI

struct HallListView: View {
    @State private var viewModel = HallListViewModel()

    var body: some View {
        NavigationStack {
            LoadStateView(state: viewModel.state, retry: { Task { await viewModel.load() } }) { halls in
                // List is scrollable by default.
                List(halls) { hall in
                    // `value:` navigation: pushes whatever .navigationDestination(for:) matches.
                    NavigationLink(value: hall) {
                        HallRow(hall: hall)
                    }
                }
                .refreshable { await viewModel.load(isRefresh: true) }
            }
            .navigationTitle("Dining Halls")
            .navigationDestination(for: DiningHall.self) { HallMenuView(hall: $0) }
            .task { await viewModel.load() }
        }
    }
}

private struct HallRow: View {
    let hall: DiningHall

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(hall.name).font(.headline)
                Spacer()
                Text(hall.openNow ? "Open" : "Closed")
                    .font(.caption.bold())
                    .foregroundStyle(hall.openNow ? .green : .secondary)
            }
            Text("\(hall.location) · \(hall.hoursSummary)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
