//
//  RouterTests.swift
//  ARCNavigationTests
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import Testing
@testable import ARCNavigation
import SwiftUI

// MARK: - Mock Route para testing

enum MockRoute: Route {
    case screen1
    case screen2
    case screen3
    case detail(id: Int)

    func view() -> some View {
        Text("Mock View")
    }
}

// MARK: - Tests Básicos

@Test("Router inicia vacío")
func routerStartsEmpty() {
    let router = Router<MockRoute>()
    #expect(router.isEmpty)
}

@Test("Navigate añade ruta al stack")
func navigateAddsRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)

    #expect(router.count == 1)
    #expect(!router.isEmpty)
    #expect(router.currentRoutes == [.screen1])
}

@Test("Navigate múltiple construye stack correcto")
func multipleNavigatesWork() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .screen3)

    #expect(router.count == 3)
    #expect(router.currentRoutes == [.screen1, .screen2, .screen3])
}

// MARK: - Tests de Pop

@Test("Pop elimina última ruta")
func popRemovesLastRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.pop()

    #expect(router.count == 1)
    #expect(router.currentRoutes == [.screen1])
}

@Test("Pop en stack vacío no crashea")
func popOnEmptyStackIsSafe() {
    let router = Router<MockRoute>()

    router.pop() // No debe crashear

    #expect(router.isEmpty)
}

@Test("PopToRoot limpia stack completo")
func popToRootClearsStack() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .screen3)

    router.popToRoot()

    #expect(router.isEmpty)
}

// MARK: - Tests de PopTo

@Test("PopTo ruta específica funciona")
func popToSpecificRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .screen3)

    router.popTo(.screen1)

    #expect(router.count == 1)
    #expect(router.currentRoutes == [.screen1])
}

@Test("PopTo ruta inexistente no hace nada")
func popToNonExistentRouteSafe() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    let originalCount = router.count

    router.popTo(.screen3) // Esta ruta no está en el stack

    #expect(router.count == originalCount)
}

// MARK: - Tests con Associated Values

@Test("Routes con associated values funcionan")
func routesWithAssociatedValues() {
    let router = Router<MockRoute>()

    router.navigate(to: .detail(id: 42))
    router.navigate(to: .detail(id: 99))

    #expect(router.count == 2)
    #expect(router.currentRoutes[0] == .detail(id: 42))
    #expect(router.currentRoutes[1] == .detail(id: 99))
}

// MARK: - Tests de Flujos Complejos

@Test("Flujo completo de navegación")
func complexNavigationFlow() {
    let router = Router<MockRoute>()

    // Navegar hacia adelante
    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .detail(id: 1))
    #expect(router.count == 3)

    // Pop una vez
    router.pop()
    #expect(router.count == 2)

    // Navegar a otra parte
    router.navigate(to: .screen3)
    #expect(router.count == 3)

    // PopTo específico
    router.popTo(.screen1)
    #expect(router.count == 1)

    // PopToRoot
    router.popToRoot()
    #expect(router.isEmpty)
}
