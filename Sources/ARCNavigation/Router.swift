//
//  Router.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI

/// Router centralizado para gestionar navegación type-safe en SwiftUI
///
/// Ejemplo de uso:
/// ```swift
/// let router = Router<AppRoute>()
/// router.navigate(to: .profile(userID: "123"))
/// router.pop()
/// ```
@Observable
public final class Router<R: Route> {
    // MARK: - Properties

    /// NavigationPath que maneja el stack de navegación
    public var path = NavigationPath()

    /// Array interno para tracking de rutas (útil para debugging y testing)
    private var routes: [R] = []

    // MARK: - Initialization

    public init() {}

    // MARK: - Core Navigation

    /// Navega a una nueva ruta
    /// - Parameter route: La ruta de destino
    public func navigate(to route: R) {
        routes.append(route)
        path.append(route)
    }

    /// Retrocede una pantalla en el stack
    /// Si el stack está vacío, no hace nada
    public func pop() {
        guard !routes.isEmpty else { return }
        routes.removeLast()
        path.removeLast()
    }

    /// Retrocede a la raíz del stack (primera pantalla)
    public func popToRoot() {
        routes.removeAll()
        path.removeLast(path.count)
    }

    /// Retrocede hasta una ruta específica
    /// - Parameter route: La ruta destino
    /// Si la ruta no existe en el stack, no hace nada
    public func popTo(_ route: R) {
        guard let index = routes.firstIndex(of: route) else { return }
        let countToRemove = routes.count - index - 1
        routes.removeLast(countToRemove)
        path.removeLast(countToRemove)
    }

    // MARK: - Testing & Debugging Helpers

    /// Acceso de solo lectura al array de rutas actuales
    /// Útil para testing y debugging
    public var currentRoutes: [R] { routes }

    /// Indica si el stack está vacío
    public var isEmpty: Bool { routes.isEmpty }

    /// Número de pantallas en el stack
    public var count: Int { routes.count }
}
