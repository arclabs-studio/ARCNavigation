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
        NavigationStack(path: router.path) {
            self
                .navigationDestination(for: R.self, destination: destination)
        }
        .environment(router)
    }
}
