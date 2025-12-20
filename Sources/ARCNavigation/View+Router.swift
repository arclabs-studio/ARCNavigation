//
//  View+Router.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI

// MARK: - View Extension

public extension View {
    /// Configura el router de navegación para esta view hierarchy
    ///
    /// - Parameters:
    ///   - router: El router a utilizar
    ///   - destination: Closure que retorna la vista para cada ruta
    ///
    /// Ejemplo de uso:
    /// ```swift
    /// ContentView()
    ///     .withRouter(router) { route in
    ///         route.view()
    ///     }
    /// ```
    func withRouter<R: Route>(
        _ router: Router<R>,
        @ViewBuilder destination: @escaping (R) -> some View
    ) -> some View {
        RouterNavigationStack(router: router, content: self, destination: destination)
    }
}

// MARK: - Private Navigation Stack Wrapper

/// Vista interna que envuelve NavigationStack con el binding correcto
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
