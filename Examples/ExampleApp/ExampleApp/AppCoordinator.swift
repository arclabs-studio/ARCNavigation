//
//  AppCoordinator.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import ARCNavigation
import SwiftUI

/// Central navigation coordinator for the example application.
/// Demonstrates the `TabCoordinator` protocol with `TabRouter`.
@Observable
@MainActor
final class AppCoordinator: TabCoordinator {
    // MARK: - Properties

    let tabRouter = TabRouter<AppTab, AppRoute>(initialTab: .home)

    // MARK: - TabCoordinator

    func makeView(for route: AppRoute) -> some View {
        route.view()
    }
}
