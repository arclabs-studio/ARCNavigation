//
//  AppRoute.swift
//  ARCNavigationDemo
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI
import ARCNavigation

enum AppRoute: Route {
    case home
    case profile(userName: String)
    case settings
    case detail(id: Int)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .profile(let userName):
            ProfileView(userName: userName)
        case .settings:
            SettingsView()
        case .detail(let id):
            DetailView(id: id)
        }
    }
}
