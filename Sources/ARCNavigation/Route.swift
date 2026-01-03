//
//  Route.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI

/// A protocol that all app routes must conform to.
///
/// The `Route` protocol defines the contract for type-safe navigation destinations.
/// Routes are typically implemented as enums with associated values to pass data
/// between screens.
///
/// ## Overview
///
/// Implement this protocol by creating an enum where each case represents
/// a navigation destination. The `view()` method returns the corresponding
/// SwiftUI view for each route.
///
/// ## Example
///
/// ```swift
/// enum AppRoute: Route {
///     case home
///     case profile(userID: String)
///     case settings
///
///     @ViewBuilder
///     func view() -> some View {
///         switch self {
///         case .home:
///             HomeView()
///         case .profile(let id):
///             ProfileView(userID: id)
///         case .settings:
///             SettingsView()
///         }
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Creating Routes
/// - ``view()``
@MainActor
public protocol Route: Hashable {
    associatedtype Destination: View

    /// Returns the view corresponding to this route.
    ///
    /// Implement this method to provide the destination view for each route case.
    /// Use a switch statement to handle all cases and return the appropriate view.
    ///
    /// - Returns: The SwiftUI view for this route.
    @ViewBuilder func view() -> Destination
}
