//
//  Route.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI

/// Protocol que deben conformar todos los routes de la app
///
/// Ejemplo de implementación:
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
@MainActor
public protocol Route: Hashable {
    associatedtype Destination: View

    /// Retorna la vista correspondiente a esta ruta
    @ViewBuilder func view() -> Destination
}
