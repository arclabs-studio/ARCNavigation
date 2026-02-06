//
//  TabRouterTests.swift
//  ARCNavigationTests
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import Testing
@testable import ARCNavigation

// MARK: - TabRouter Tests

@Suite("TabRouter")
@MainActor
struct TabRouterTests {

    // MARK: - Helpers

    private func makeSUT(initialTab: TestTab? = nil) -> TabRouter<TestTab, TestRoute> {
        TabRouter(initialTab: initialTab)
    }

    // MARK: - Initial State

    @Test("Starts with first tab as active")
    func initialStateDefaultTab() {
        let sut = makeSUT()

        #expect(sut.activeTab == .home)
        #expect(sut.isSearchActive == false)
        #expect(sut.hasAnyNavigation == false)
    }

    @Test("Starts with custom initial tab")
    func initialStateCustomTab() {
        let sut = makeSUT(initialTab: .settings)

        #expect(sut.activeTab == .settings)
    }

    // MARK: - Navigation

    @Test("Navigate pushes to active tab only")
    func navigateToActiveTab() {
        let sut = makeSUT()

        sut.navigate(to: .page1)

        #expect(sut.activeRouter.count == 1)
        #expect(sut.depth(for: .home) == 1)
        #expect(sut.depth(for: .explore) == 0)
    }

    @Test("Navigate to specific tab switches and pushes")
    func navigateToSpecificTab() {
        let sut = makeSUT()

        sut.navigate(to: .page1, in: .explore)

        #expect(sut.activeTab == .explore)
        #expect(sut.depth(for: .explore) == 1)
        #expect(sut.depth(for: .home) == 0)
    }

    @Test("Navigate in search context when search is active")
    func navigateInSearchContext() {
        let sut = makeSUT()
        sut.isSearchActive = true

        sut.navigate(to: .page1)

        #expect(sut.search.count == 1)
        #expect(sut.depth(for: .home) == 0)
    }

    // MARK: - Pop

    @Test("Pop removes from active tab")
    func popFromActiveTab() {
        let sut = makeSUT()
        sut.navigate(to: .page1)
        sut.navigate(to: .page2)

        sut.pop()

        #expect(sut.depth(for: .home) == 1)
    }

    @Test("PopToRoot clears active tab only")
    func popToRootClearsActiveTab() {
        let sut = makeSUT()

        // Push to home tab
        sut.navigate(to: .page1)
        sut.navigate(to: .page2)

        // Push to explore tab
        sut.navigate(to: .detail(id: 1), in: .explore)

        // Pop to root on explore (now active)
        sut.popToRoot()

        #expect(sut.depth(for: .explore) == 0)
        #expect(sut.depth(for: .home) == 2)
    }

    // MARK: - Tab Isolation

    @Test("Tabs have independent navigation stacks")
    func tabIsolation() {
        let sut = makeSUT()

        // Push to home
        sut.navigate(to: .page1)

        // Switch to explore and push
        sut.activeTab = .explore
        sut.navigate(to: .page2)
        sut.navigate(to: .detail(id: 42))

        #expect(sut.depth(for: .home) == 1)
        #expect(sut.depth(for: .explore) == 2)
        #expect(sut.depth(for: .settings) == 0)
    }

    // MARK: - Depth

    @Test("Depth tracks per-tab navigation count")
    func depthTracking() {
        let sut = makeSUT()

        #expect(sut.depth(for: .home) == 0)

        sut.navigate(to: .page1)
        sut.navigate(to: .page2)

        #expect(sut.depth(for: .home) == 2)
    }

    // MARK: - Reset

    @Test("ResetAll clears all tabs and search")
    func resetAll() {
        let sut = makeSUT()

        // Push to multiple tabs
        sut.navigate(to: .page1)
        sut.navigate(to: .detail(id: 1), in: .explore)
        sut.isSearchActive = true
        sut.navigate(to: .page2)

        sut.resetAll()

        #expect(sut.depth(for: .home) == 0)
        #expect(sut.depth(for: .explore) == 0)
        #expect(sut.search.isEmpty)
        #expect(sut.isSearchActive == false)
        #expect(sut.hasAnyNavigation == false)
    }

    // MARK: - Binding

    @Test("ActiveTabBinding clears search on tab switch")
    func activeTabBindingClearsSearch() {
        let sut = makeSUT()
        sut.isSearchActive = true

        sut.activeTabBinding.wrappedValue = .explore

        #expect(sut.activeTab == .explore)
        #expect(sut.isSearchActive == false)
    }

    @Test("Navigate in tab clears search flag")
    func navigateInTabClearsSearch() {
        let sut = makeSUT()
        sut.isSearchActive = true

        sut.navigate(to: .page1, in: .settings)

        #expect(sut.isSearchActive == false)
        #expect(sut.activeTab == .settings)
    }
}
