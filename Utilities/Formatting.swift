//
//  Formatting.swift
//  Small helpers shared by several views.
//
import Foundation

/// 0.5 -> "½×", 1.0 -> "1×", 1.5 -> "1.5×"
func portionLabel(_ portion: Double) -> String {
    portion == 0.5 ? "½×" : "\(portion.formatted())×"
}

extension Double {
    /// Rounds to a whole number for display: 41.6 -> "42"
    var rounded0: String { String(Int(self.rounded())) }
}

extension Error {
    /// True when a request was cancelled (e.g. user left the screen).
    /// We ignore these instead of showing an error message.
    var isCancellation: Bool {
        self is CancellationError || (self as? URLError)?.code == .cancelled
    }
}
