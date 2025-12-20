//
//  ARCNavigationDemoApp.swift
//  ARCNavigationDemo
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI
import ARCNavigation

@main
struct ARCNavigationDemoApp: App {

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
