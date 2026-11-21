//
//  CampusMacrosApp.swift
//  App entry point. Creates app-wide state and shows the tab bar.
//
import SwiftUI

@main
struct CampusMacrosApp: App {
    // One shared "plate" for the whole app. Any screen can read/modify it via
    // `@Environment(PlateViewModel.self)`.
    @State private var plate = PlateViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(plate)
        }
    }
}
