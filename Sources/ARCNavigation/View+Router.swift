//
//  View+Router.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI

// MARK: - View Extension

public extension View {
    /// Configures the navigation router for this view hierarchy.
    ///
    /// This modifier wraps the view in a `NavigationStack` and injects the
    /// router into the environment, making it accessible to all child views
    /// via `@Environment(Router<R>.self)`.
    ///
    /// - Parameters:
    ///   - router: The router instance to use for navigation.
    ///   - destination: A closure that returns the destination view for each route.
    ///
    /// - Returns: A view with navigation stack and router configured.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @State private var router = Router<AppRoute>()
    ///
    /// var body: some Scene {
    ///     WindowGroup {
    ///         ContentView()
    ///             .withRouter(router) { route in
    ///                 route.view()
    ///             }
    ///     }
    /// }
    /// ```
    func withRouter<R: Route>(
        _ router: Router<R>,
        @ViewBuilder destination: @escaping (R) -> some View
    ) -> some View {
        RouterNavigationStack(router: router, content: self, destination: destination)
    }
}

// MARK: - Private Navigation Stack Wrapper

/// Internal view that wraps NavigationStack with the correct binding.
private struct RouterNavigationStack<R: Route, Content: View, Destination: View>: View {
    @Bindable var router: Router<R>
    let content: Content
    let destination: (R) -> Destination

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: R.self, destination: destination)
        }
        .environment(router)
    }
}
