//
//  Coordinator.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import SwiftUI

/// A protocol for coordinators that manage view creation for routes.
///
/// Coordinators centralize the mapping between routes and their
/// corresponding views, separating navigation logic from view code.
///
/// ## Overview
///
/// Implement this protocol to create a coordinator that knows how
/// to build the destination view for each route. This enables the
/// coordinator pattern where navigation decisions are made outside
/// of individual views.
///
/// ## Example
///
/// ```swift
/// @Observable
/// @MainActor
/// final class AppCoordinator: Coordinator {
///     @ViewBuilder
///     func makeView(for route: AppRoute) -> some View {
///         switch route {
///         case .home:
///             HomeView()
///         case .profile(let user):
///             ProfileView(user: user)
///         }
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### View Creation
/// - ``makeView(for:)``
@MainActor
public protocol Coordinator: AnyObject, Observable {
    associatedtype R: Route
    associatedtype RouteView: View

    /// Creates the destination view for a given route.
    ///
    /// - Parameter route: The route to create a view for.
    /// - Returns: The SwiftUI view corresponding to the route.
    @ViewBuilder func makeView(for route: R) -> RouteView
}

/// A coordinator that manages tab-based navigation.
///
/// `TabCoordinator` extends `Coordinator` with a ``tabRouter``
/// and provides default navigation methods that delegate to it.
///
/// ## Overview
///
/// Implement this protocol to create a coordinator that owns
/// a `TabRouter` and serves as the central navigation authority
/// for your app.
///
/// ## Example
///
/// ```swift
/// @Observable
/// @MainActor
/// final class AppCoordinator: TabCoordinator {
///     let tabRouter = TabRouter<AppTab, AppRoute>()
///
///     @ViewBuilder
///     func makeView(for route: AppRoute) -> some View {
///         route.view()
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Tab Router
/// - ``tabRouter``
///
/// ### Default Navigation
/// - ``navigate(to:)``
/// - ``navigate(to:in:)``
/// - ``pop()``
/// - ``popToRoot()``
@MainActor
public protocol TabCoordinator: Coordinator {
    associatedtype Tab: NavigationTab

    /// The tab router managing per-tab navigation stacks.
    var tabRouter: TabRouter<Tab, R> { get }
}

// MARK: - TabCoordinator Default Implementations

public extension TabCoordinator {

    /// Navigates to a route in the active tab.
    ///
    /// Delegates to ``TabRouter/navigate(to:)``.
    ///
    /// - Parameter route: The destination route.
    func navigate(to route: R) {
        tabRouter.navigate(to: route)
    }

    /// Navigates to a route in a specific tab.
    ///
    /// Delegates to ``TabRouter/navigate(to:in:)``.
    ///
    /// - Parameters:
    ///   - route: The destination route.
    ///   - tab: The tab to navigate in.
    func navigate(to route: R, in tab: Tab) {
        tabRouter.navigate(to: route, in: tab)
    }

    /// Pops the top route from the active context.
    ///
    /// Delegates to ``TabRouter/pop()``.
    func pop() {
        tabRouter.pop()
    }

    /// Pops to the root of the active context.
    ///
    /// Delegates to ``TabRouter/popToRoot()``.
    func popToRoot() {
        tabRouter.popToRoot()
    }
}
