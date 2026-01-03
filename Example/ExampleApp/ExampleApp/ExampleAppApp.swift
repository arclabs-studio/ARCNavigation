//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import ARCNavigation
import SwiftUI

/// Main entry point for the ARCNavigation example application.
/// Demonstrates type-safe navigation with Router and Route protocol.
@main
struct ExampleAppApp: App {

    // MARK: - Properties

    @State private var router = Router<AppRoute>()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            HomeView()
                .withRouter(router) { route in
                    route.view()
                }
        }
    }
}
