//
//  CoordinatorTests.swift
//  ARCNavigationTests
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import SwiftUI
import Testing
@testable import ARCNavigation

// MARK: - Mock Coordinator

@Observable
@MainActor
private final class MockCoordinator: TabCoordinator {
    let tabRouter = TabRouter<TestTab, TestRoute>()

    func makeView(for _: TestRoute) -> some View {
        EmptyView()
    }
}

// MARK: - TabCoordinator Tests

@Suite("TabCoordinator")
@MainActor
struct CoordinatorTests {
    // MARK: - Helpers

    private func makeSUT() -> MockCoordinator {
        MockCoordinator()
    }

    // MARK: - Default Navigation

    @Test("Navigate delegates to tabRouter") func navigateDelegatesToTabRouter() {
        let sut = makeSUT()

        sut.navigate(to: .page1)

        #expect(sut.tabRouter.activeRouter.count == 1)
        #expect(sut.tabRouter.activeRouter.currentRoutes == [.page1])
    }

    @Test("Pop delegates to tabRouter") func popDelegatesToTabRouter() {
        let sut = makeSUT()
        sut.navigate(to: .page1)
        sut.navigate(to: .page2)

        sut.pop()

        #expect(sut.tabRouter.activeRouter.count == 1)
    }

    @Test("PopToRoot delegates to tabRouter") func popToRootDelegatesToTabRouter() {
        let sut = makeSUT()
        sut.navigate(to: .page1)
        sut.navigate(to: .page2)

        sut.popToRoot()

        #expect(sut.tabRouter.activeRouter.isEmpty)
    }

    @Test("Navigate in specific tab delegates to tabRouter") func navigateInSpecificTabDelegatesToTabRouter() {
        let sut = makeSUT()

        sut.navigate(to: .detail(id: 1), in: .explore)

        #expect(sut.tabRouter.activeTab == .explore)
        #expect(sut.tabRouter.depth(for: .explore) == 1)
    }
}
