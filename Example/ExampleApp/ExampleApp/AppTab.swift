//
//  AppTab.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import ARCNavigation
import SwiftUI

/// Defines the tabs available in the example application.
/// Demonstrates the `NavigationTab` protocol.
enum AppTab: String, NavigationTab {
    case home
    case explore
    case settings

    // MARK: - NavigationTab

    nonisolated var id: String {
        rawValue
    }

    var title: LocalizedStringKey {
        switch self {
        case .home: "Home"
        case .explore: "Explore"
        case .settings: "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: "house"
        case .explore: "magnifyingglass"
        case .settings: "gearshape"
        }
    }
}
