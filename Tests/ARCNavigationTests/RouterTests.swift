//
//  RouterTests.swift
//  ARCNavigationTests
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import Testing
@testable import ARCNavigation
import SwiftUI

// MARK: - Mock Route for Testing

enum MockRoute: Route {
    case screen1
    case screen2
    case screen3
    case detail(id: Int)

    func view() -> some View {
        Text("Mock View")
    }
}

// MARK: - Basic Tests

@Test("Router starts empty")
func routerStartsEmpty() {
    let router = Router<MockRoute>()
    #expect(router.isEmpty)
}

@Test("Navigate adds route to stack")
func navigateAddsRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)

    #expect(router.count == 1)
    #expect(!router.isEmpty)
    #expect(router.currentRoutes == [.screen1])
}

@Test("Multiple navigates build correct stack")
func multipleNavigatesWork() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .screen3)

    #expect(router.count == 3)
    #expect(router.currentRoutes == [.screen1, .screen2, .screen3])
}

// MARK: - Pop Tests

@Test("Pop removes last route")
func popRemovesLastRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.pop()

    #expect(router.count == 1)
    #expect(router.currentRoutes == [.screen1])
}

@Test("Pop on empty stack is safe")
func popOnEmptyStackIsSafe() {
    let router = Router<MockRoute>()

    router.pop() // Should not crash

    #expect(router.isEmpty)
}

@Test("PopToRoot clears entire stack")
func popToRootClearsStack() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .screen3)

    router.popToRoot()

    #expect(router.isEmpty)
}

// MARK: - PopTo Tests

@Test("PopTo specific route works")
func popToSpecificRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .screen3)

    router.popTo(.screen1)

    #expect(router.count == 1)
    #expect(router.currentRoutes == [.screen1])
}

@Test("PopTo non-existent route does nothing")
func popToNonExistentRouteSafe() {
    let router = Router<MockRoute>()

    router.navigate(to: .screen1)
    let originalCount = router.count

    router.popTo(.screen3) // This route is not in the stack

    #expect(router.count == originalCount)
}

// MARK: - Associated Values Tests

@Test("Routes with associated values work")
func routesWithAssociatedValues() {
    let router = Router<MockRoute>()

    router.navigate(to: .detail(id: 42))
    router.navigate(to: .detail(id: 99))

    #expect(router.count == 2)
    #expect(router.currentRoutes[0] == .detail(id: 42))
    #expect(router.currentRoutes[1] == .detail(id: 99))
}

// MARK: - Complex Flow Tests

@Test("Complex navigation flow")
func complexNavigationFlow() {
    let router = Router<MockRoute>()

    // Navigate forward
    router.navigate(to: .screen1)
    router.navigate(to: .screen2)
    router.navigate(to: .detail(id: 1))
    #expect(router.count == 3)

    // Pop once
    router.pop()
    #expect(router.count == 2)

    // Navigate elsewhere
    router.navigate(to: .screen3)
    #expect(router.count == 3)

    // PopTo specific
    router.popTo(.screen1)
    #expect(router.count == 1)

    // PopToRoot
    router.popToRoot()
    #expect(router.isEmpty)
}
