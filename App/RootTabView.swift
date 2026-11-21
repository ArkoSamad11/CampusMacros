//
//  RootTabView.swift
//  The bottom tab bar. Each tab owns its own NavigationStack (inside the tab's view),
//  so navigation history is kept separately per tab.
//
import SwiftUI

struct RootTabView: View {
    @Environment(PlateViewModel.self) private var plate

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            HallListView()
                .tabItem { Label("Menus", systemImage: "fork.knife") }

            PlateView()
                .tabItem { Label("Plate", systemImage: "tray.full") }
                .badge(plate.items.count) // badge hides automatically when 0

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}
