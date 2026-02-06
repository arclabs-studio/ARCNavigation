//
//  View+TabRouter.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import SwiftUI

// MARK: - View Extension

public extension View {
    /// Configures tab-based navigation for a specific tab.
    ///
    /// This modifier wraps the view in a `NavigationStack` bound to the
    /// tab's router and injects both the per-tab `Router` and the
    /// `TabRouter` into the environment.
    ///
    /// - Parameters:
    ///   - tabRouter: The tab router managing all tabs.
    ///   - tab: The tab this view belongs to.
    ///   - destination: A closure that returns the destination view for each route.
    ///
    /// - Returns: A view with tab navigation configured.
    ///
    /// ## Example
    ///
    /// ```swift
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
    func withTabNavigation<Tab: NavigationTab, R: Route>(
        _ tabRouter: TabRouter<Tab, R>,
        for tab: Tab,
        @ViewBuilder destination: @escaping (R) -> some View
    ) -> some View {
        TabNavigationStack(
            tabRouter: tabRouter,
            tab: tab,
            content: self,
            destination: destination
        )
    }
}

// MARK: - Private Navigation Stack Wrapper

/// Internal view that wraps NavigationStack with the correct per-tab binding.
private struct TabNavigationStack<
    Tab: NavigationTab,
    R: Route,
    Content: View,
    Destination: View
>: View {
    @Bindable var tabRouter: TabRouter<Tab, R>
    let tab: Tab
    let content: Content
    let destination: (R) -> Destination

    var body: some View {
        @Bindable var router = tabRouter.router(for: tab)

        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: R.self, destination: destination)
        }
        .environment(router)
        .environment(tabRouter)
    }
}
