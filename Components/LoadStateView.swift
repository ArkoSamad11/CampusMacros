//
//  LoadStateView.swift
//  Reusable wrapper: shows a spinner, an error with a retry button, or your content.
//  Usage:
//      LoadStateView(state: vm.state, retry: { ... }) { value in
//          // build UI from the loaded value
//      }
//
import SwiftUI

struct LoadStateView<Value, Content: View>: View {
    let state: LoadState<Value>
    let retry: () -> Void
    @ViewBuilder let content: (Value) -> Content

    var body: some View {
        switch state {
        case .idle, .loading:
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, minHeight: 200)

        case .loaded(let value):
            content(value)

        case .failed(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try again", action: retry)
            }
        }
    }
}
