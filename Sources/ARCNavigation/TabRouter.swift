//
//  TabRouter.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import ARCLogger
import SwiftUI

/// A centralized router for managing tab-based navigation with per-tab stacks.
///
/// `TabRouter` manages independent `Router` instances for each tab, ensuring
/// navigation state is isolated between tabs. It also provides a dedicated
/// search context for search-driven navigation.
///
/// ## Overview
///
/// Create a `TabRouter` at your app's root level and use it with `TabView`
/// to provide independent navigation stacks for each tab.
///
/// ## Example
///
/// ```swift
/// @State private var tabRouter = TabRouter<AppTab, AppRoute>()
///
/// TabView(selection: tabRouter.activeTabBinding) {
///     ForEach(AppTab.allCases) { tab in
///         ContentView()
///             .withTabNavigation(tabRouter, for: tab) { route in
///                 route.view()
///             }
///             .tabItem {
///                 Label(tab.title, systemImage: tab.icon)
///             }
///             .tag(tab)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Router Access
/// - ``router(for:)``
/// - ``activeRouter``
/// - ``search``
///
/// ### Navigation
/// - ``navigate(to:)``
/// - ``navigate(to:in:)``
/// - ``pop()``
/// - ``popToRoot()``
/// - ``popTo(_:)``
///
/// ### State Inspection
/// - ``activeTab``
/// - ``isSearchActive``
/// - ``isShowingDetail``
/// - ``hasAnyNavigation``
/// - ``depth(for:)``
///
/// ### Reset
/// - ``resetAll()``
///
/// ### Configuration
/// - ``loggingEnabled``
@Observable
@MainActor public final class TabRouter<Tab: NavigationTab, R: Route> {
    // MARK: - Private Properties

    /// Per-tab routers, lazily created on first access.
    private var tabRouters: [Tab: Router<R>] = [:]

    /// Dedicated router for search context navigation.
    private var searchRouter: Router<R>

    /// Logger instance for tab navigation operations.
    private let logger = ARCLogger(subsystem: "studio.arclabs.ARCNavigation",
                                   category: "TabRouter")

    // MARK: - Public Properties

    /// The currently active tab.
    public var activeTab: Tab

    /// Whether the search context is currently active.
    public var isSearchActive = false

    /// Enables or disables logging for all managed routers.
    ///
    /// When set, propagates the value to all existing tab routers
    /// and the search router.
    public var loggingEnabled: Bool {
        didSet {
            for router in tabRouters.values {
                router.loggingEnabled = loggingEnabled
            }
            searchRouter.loggingEnabled = loggingEnabled
        }
    }

    // MARK: - Initialization

    /// Creates a new tab router instance.
    ///
    /// - Parameters:
    ///   - initialTab: The tab to start on. Defaults to the first case of the tab enum.
    ///   - loggingEnabled: Whether to log navigation operations. Defaults to `false`.
    public init(initialTab: Tab? = nil, loggingEnabled: Bool = false) {
        guard let tab = initialTab ?? Tab.allCases.first else {
            preconditionFailure("NavigationTab must have at least one case")
        }
        activeTab = tab
        self.loggingEnabled = loggingEnabled
        searchRouter = Router<R>(loggingEnabled: loggingEnabled)
    }

    // MARK: - Router Access

    /// Returns the router for a specific tab, creating it lazily if needed.
    ///
    /// Each tab has its own independent `Router` instance, ensuring
    /// navigation stacks don't interfere with each other.
    ///
    /// - Parameter tab: The tab to get the router for.
    /// - Returns: The `Router` instance for the specified tab.
    public func router(for tab: Tab) -> Router<R> {
        if let existing = tabRouters[tab] {
            return existing
        }
        let router = Router<R>(loggingEnabled: loggingEnabled)
        tabRouters[tab] = router
        return router
    }

    /// The router for the currently active tab.
    public var activeRouter: Router<R> {
        router(for: activeTab)
    }

    /// The router for the search navigation context.
    public var search: Router<R> {
        searchRouter
    }

    // MARK: - Navigation

    /// Navigates to a route in the active tab.
    ///
    /// If the search context is active, navigation occurs in the
    /// search router instead.
    ///
    /// - Parameter route: The destination route to navigate to.
    public func navigate(to route: R) {
        if isSearchActive {
            searchRouter.navigate(to: route)
        } else {
            activeRouter.navigate(to: route)
        }

        if loggingEnabled {
            let context = isSearchActive ? "search" : String(describing: activeTab)
            logger.debug("Navigated to route", metadata: ["route": .public(String(describing: route)),
                                                          "context": .public(context)])
        }
    }

    /// Navigates to a route in a specific tab.
    ///
    /// Switches to the specified tab and pushes the route onto
    /// that tab's navigation stack. Clears the search context.
    ///
    /// - Parameters:
    ///   - route: The destination route to navigate to.
    ///   - tab: The tab to navigate in.
    public func navigate(to route: R, in tab: Tab) {
        activeTab = tab
        isSearchActive = false
        router(for: tab).navigate(to: route)

        if loggingEnabled {
            logger.debug("Navigated to route in tab", metadata: ["route": .public(String(describing: route)),
                                                                 "tab": .public(String(describing: tab))])
        }
    }

    /// Pops the top route from the active context.
    ///
    /// Pops from the search router if search is active,
    /// otherwise pops from the active tab's router.
    public func pop() {
        if isSearchActive {
            searchRouter.pop()
        } else {
            activeRouter.pop()
        }
    }

    /// Pops to the root of the active context.
    ///
    /// Clears the navigation stack of the search router if search
    /// is active, otherwise clears the active tab's router.
    public func popToRoot() {
        if isSearchActive {
            searchRouter.popToRoot()
        } else {
            activeRouter.popToRoot()
        }
    }

    /// Pops to a specific route in the active context.
    ///
    /// - Parameter route: The target route to pop back to.
    public func popTo(_ route: R) {
        if isSearchActive {
            searchRouter.popTo(route)
        } else {
            activeRouter.popTo(route)
        }
    }

    // MARK: - State Inspection

    /// Whether any tab or the search context has navigation depth.
    public var isShowingDetail: Bool {
        if isSearchActive {
            return !searchRouter.isEmpty
        }
        return !activeRouter.isEmpty
    }

    /// Whether any tab or search context has routes pushed.
    public var hasAnyNavigation: Bool {
        let hasTabNavigation = tabRouters.values.contains { !$0.isEmpty }
        return hasTabNavigation || !searchRouter.isEmpty
    }

    /// Returns the navigation depth for a specific tab.
    ///
    /// - Parameter tab: The tab to check.
    /// - Returns: The number of routes in the tab's navigation stack.
    public func depth(for tab: Tab) -> Int {
        tabRouters[tab]?.count ?? 0
    }

    // MARK: - Reset

    /// Resets all tab navigation stacks and the search context.
    ///
    /// Pops to root on every tab router and the search router,
    /// and deactivates the search context.
    public func resetAll() {
        for router in tabRouters.values {
            router.popToRoot()
        }
        searchRouter.popToRoot()
        isSearchActive = false

        if loggingEnabled {
            logger.debug("Reset all navigation stacks")
        }
    }

    // MARK: - Binding

    /// A binding to the active tab that clears search on tab switch.
    ///
    /// Use this binding with `TabView(selection:)` to automatically
    /// deactivate the search context when the user switches tabs.
    public var activeTabBinding: Binding<Tab> {
        Binding(get: { self.activeTab },
                set: { newTab in
                    self.activeTab = newTab
                    self.isSearchActive = false

                    if self.loggingEnabled {
                        self.logger.debug("Switched tab", metadata: ["tab": .public(String(describing: newTab))])
                    }
                })
    }
}
