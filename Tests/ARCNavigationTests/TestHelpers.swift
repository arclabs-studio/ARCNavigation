//
//  TestHelpers.swift
//  ARCNavigationTests
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import SwiftUI
@testable import ARCNavigation

// MARK: - TestTab

/// Mock tab enum for testing tab-based navigation.
enum TestTab: String, NavigationTab, CaseIterable {
    case home
    case explore
    case settings

    // MARK: - NavigationTab

    nonisolated var id: String { rawValue }

    var title: String {
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

// MARK: - TestRoute

/// Mock route enum for testing tab-based navigation with EmptyView default.
enum TestRoute: Route {
    case page1
    case page2
    case detail(id: Int)
}
