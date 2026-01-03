//
//  Router.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI

/// A centralized router for managing type-safe navigation in SwiftUI.
///
/// `Router` provides a clean API for programmatic navigation in SwiftUI apps.
/// It manages a `NavigationPath` and tracks routes internally for testing
/// and debugging purposes.
///
/// ## Overview
///
/// Create a `Router` instance at your app's root level and inject it into
/// your view hierarchy using the `.withRouter(_:destination:)` modifier.
/// Child views can then access the router via `@Environment` to perform
/// navigation.
///
/// ## Example
///
/// ```swift
/// // Create router in App
/// @State private var router = Router<AppRoute>()
///
/// // Use router in views
/// @Environment(Router<AppRoute>.self) private var router
///
/// // Navigate
/// router.navigate(to: .profile(userID: "123"))
/// router.pop()
/// router.popToRoot()
/// ```
///
/// ## Topics
///
/// ### Navigation
/// - ``navigate(to:)``
/// - ``pop()``
/// - ``popToRoot()``
/// - ``popTo(_:)``
///
/// ### State Inspection
/// - ``currentRoutes``
/// - ``isEmpty``
/// - ``count``
/// - ``path``
@Observable
public final class Router<R: Route> {
    // MARK: Properties

    /// The navigation path that manages the navigation stack.
    ///
    /// This property is bindable and used by `NavigationStack` to control
    /// the current navigation state.
    public var path = NavigationPath()

    /// Internal array for route tracking (useful for debugging and testing).
    private var routes: [R] = []

    // MARK: Initialization

    /// Creates a new router instance.
    ///
    /// The router starts with an empty navigation stack.
    public init() {}

    // MARK: Core Navigation

    /// Navigates to a new route.
    ///
    /// Pushes the specified route onto the navigation stack, causing the
    /// corresponding view to be displayed.
    ///
    /// - Parameter route: The destination route to navigate to.
    ///
    /// ## Example
    ///
    /// ```swift
    /// router.navigate(to: .profile(userID: "123"))
    /// ```
    public func navigate(to route: R) {
        routes.append(route)
        path.append(route)
    }

    /// Pops the current screen from the navigation stack.
    ///
    /// Removes the topmost route from the stack, navigating back to the
    /// previous screen. If the stack is empty, this method does nothing.
    ///
    /// ## Example
    ///
    /// ```swift
    /// router.pop()
    /// ```
    public func pop() {
        guard !routes.isEmpty else { return }
        routes.removeLast()
        path.removeLast()
    }

    /// Pops all screens and returns to the root view.
    ///
    /// Removes all routes from the navigation stack, returning to the
    /// initial root view of the navigation hierarchy.
    ///
    /// ## Example
    ///
    /// ```swift
    /// router.popToRoot()
    /// ```
    public func popToRoot() {
        routes.removeAll()
        path.removeLast(path.count)
    }

    /// Pops screens until reaching a specific route.
    ///
    /// Navigates back through the stack until the specified route is at
    /// the top. If the route doesn't exist in the stack, this method
    /// does nothing.
    ///
    /// - Parameter route: The target route to navigate back to.
    ///
    /// ## Example
    ///
    /// ```swift
    /// router.navigate(to: .home)
    /// router.navigate(to: .profile(userID: "123"))
    /// router.navigate(to: .settings)
    /// router.popTo(.home)  // Pops settings and profile
    /// ```
    public func popTo(_ route: R) {
        guard let index = routes.firstIndex(of: route) else { return }
        let countToRemove = routes.count - index - 1
        routes.removeLast(countToRemove)
        path.removeLast(countToRemove)
    }

    // MARK: Testing & Debugging Helpers

    /// Read-only access to the current routes array.
    ///
    /// Use this property for testing navigation flows or debugging
    /// the current navigation state.
    ///
    /// ## Example
    ///
    /// ```swift
    /// #expect(router.currentRoutes == [.home, .profile(userID: "123")])
    /// ```
    public var currentRoutes: [R] { routes }

    /// Indicates whether the navigation stack is empty.
    ///
    /// Returns `true` when no routes have been pushed onto the stack,
    /// meaning the user is at the root view.
    public var isEmpty: Bool { routes.isEmpty }

    /// The number of screens in the navigation stack.
    ///
    /// Returns `0` when at the root view.
    public var count: Int { routes.count }
}
