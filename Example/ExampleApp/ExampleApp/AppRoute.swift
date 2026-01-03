//
//  AppRoute.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import ARCNavigation
import SwiftUI

/// Defines all navigable routes in the example application.
/// Demonstrates Route protocol usage with associated values.
enum AppRoute: Route {
    case home
    case profile(user: User)
    case settings
    case detail(id: Int)

    // MARK: - Route

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .profile(let user):
            ProfileView(user: user)
        case .settings:
            SettingsView()
        case .detail(let id):
            DetailView(id: id)
        }
    }
}
