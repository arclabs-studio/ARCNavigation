//
//  HomeViewModel.swift
//  ARCNavigationDemo
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI
import ARCNavigation

@Observable
final class HomeViewModel {

    // MARK: - Properties

    // El router se puede inyectar vía Environment o como dependencia
    private let router: Router<AppRoute>

    // MARK: - Initialization

    init(router: Router<AppRoute>) {
        self.router = router
    }

    // MARK: - Navigation Methods

    /// Ejemplo de lógica de negocio que navega
    func openUserProfile(userName: String) {
        // Aquí podrías tener validaciones, analytics, etc.
        router.navigate(to: .profile(userName: userName))
    }

    func openSettings() {
        router.navigate(to: .settings)
    }

    func openDetailIfValid(id: Int) {
        guard id > 0 else { return }
        router.navigate(to: .detail(id: id))
    }
}
