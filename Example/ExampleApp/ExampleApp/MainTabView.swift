//
//  MainTabView.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import ARCNavigation
import SwiftUI

/// Main tab view demonstrating tab-based navigation with `TabRouter`.
struct MainTabView: View {

    // MARK: - Properties

    @Environment(AppCoordinator.self) private var coordinator

    // MARK: - Body

    var body: some View {
        TabView(selection: coordinator.tabRouter.activeTabBinding) {
            homeTab
            exploreTab
            settingsTab
        }
    }

    // MARK: - Tabs

    private var homeTab: some View {
        HomeView()
            .withTabNavigation(coordinator.tabRouter, for: .home) { route in
                coordinator.makeView(for: route)
            }
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.icon)
            }
            .tag(AppTab.home)
    }

    private var exploreTab: some View {
        ExploreView()
            .withTabNavigation(coordinator.tabRouter, for: .explore) { route in
                coordinator.makeView(for: route)
            }
            .tabItem {
                Label(AppTab.explore.title, systemImage: AppTab.explore.icon)
            }
            .tag(AppTab.explore)
    }

    private var settingsTab: some View {
        SettingsView()
            .withTabNavigation(coordinator.tabRouter, for: .settings) { route in
                coordinator.makeView(for: route)
            }
            .tabItem {
                Label(AppTab.settings.title, systemImage: AppTab.settings.icon)
            }
            .tag(AppTab.settings)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    MainTabView()
        .environment(AppCoordinator())
}

#Preview("Dark Mode") {
    MainTabView()
        .environment(AppCoordinator())
        .preferredColorScheme(.dark)
}
