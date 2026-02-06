//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import ARCNavigation
import SwiftUI

/// Main entry point for the ARCNavigation example application.
/// Demonstrates tab-based navigation with TabCoordinator pattern.
@main
struct ExampleAppApp: App {

    // MARK: - Properties

    @State private var coordinator = AppCoordinator()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(coordinator)
        }
    }
}
