# Testing Guide

Learn how to test navigation flows without UI using Swift Testing.

## Overview

ARCNavigation is designed to be fully testable without requiring UI tests. The ``Router`` can be tested in isolation, allowing you to verify navigation logic quickly and reliably using Swift Testing.

## Why Test Navigation?

Navigation is a critical part of your app's user experience. Testing navigation ensures:

- Users can navigate between screens correctly
- Back navigation works as expected
- Complex multi-step flows execute properly
- Edge cases (empty stacks, invalid routes) are handled safely

## Setting Up Tests

### Import the Framework

```swift
import Testing
@testable import ARCNavigation
import SwiftUI
```

### Create Mock Routes

Define mock routes for testing:

```swift
enum MockRoute: Route {
    case home
    case profile
    case settings
    case detail(id: Int)

    func view() -> some View {
        Text("Mock View")
    }
}
```

> Tip: Keep mock routes simple. The view implementation doesn't matter for router tests.

## Basic Navigation Tests

### Test Router Initialization

```swift
@Test("Router starts empty")
func routerStartsEmpty() {
    let router = Router<MockRoute>()

    #expect(router.isEmpty)
    #expect(router.count == 0)
    #expect(router.currentRoutes.isEmpty)
}
```

### Test Single Navigation

```swift
@Test("Navigate adds route to stack")
func navigateAddsRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .profile)

    #expect(router.count == 1)
    #expect(!router.isEmpty)
    #expect(router.currentRoutes == [.profile])
}
```

### Test Multiple Navigations

```swift
@Test("Multiple navigations build correct stack")
func multipleNavigations() {
    let router = Router<MockRoute>()

    router.navigate(to: .home)
    router.navigate(to: .profile)
    router.navigate(to: .settings)

    #expect(router.count == 3)
    #expect(router.currentRoutes == [.home, .profile, .settings])
}
```

## Testing Back Navigation

### Test Pop

```swift
@Test("Pop removes last route")
func popRemovesLastRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .home)
    router.navigate(to: .profile)
    router.pop()

    #expect(router.count == 1)
    #expect(router.currentRoutes == [.home])
}
```

### Test Pop Safety

```swift
@Test("Pop on empty stack is safe")
func popOnEmptyStackIsSafe() {
    let router = Router<MockRoute>()

    router.pop() // Should not crash

    #expect(router.isEmpty)
    #expect(router.count == 0)
}
```

### Test Pop to Root

```swift
@Test("Pop to root clears entire stack")
func popToRootClearsStack() {
    let router = Router<MockRoute>()

    router.navigate(to: .home)
    router.navigate(to: .profile)
    router.navigate(to: .settings)

    router.popToRoot()

    #expect(router.isEmpty)
    #expect(router.count == 0)
}
```

## Testing Targeted Navigation

### Test Pop to Specific Route

```swift
@Test("Pop to specific route works")
func popToSpecificRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .home)
    router.navigate(to: .profile)
    router.navigate(to: .settings)

    router.popTo(.home)

    #expect(router.count == 1)
    #expect(router.currentRoutes == [.home])
}
```

### Test Pop to Non-Existent Route

```swift
@Test("Pop to non-existent route is safe")
func popToNonExistentRoute() {
    let router = Router<MockRoute>()

    router.navigate(to: .home)
    let initialCount = router.count

    router.popTo(.settings) // Not in stack

    #expect(router.count == initialCount)
    #expect(router.currentRoutes == [.home])
}
```

## Testing Associated Values

### Test Routes with Parameters

```swift
@Test("Routes with associated values work")
func routesWithAssociatedValues() {
    let router = Router<MockRoute>()

    router.navigate(to: .detail(id: 42))
    router.navigate(to: .detail(id: 99))

    #expect(router.count == 2)
    #expect(router.currentRoutes[0] == .detail(id: 42))
    #expect(router.currentRoutes[1] == .detail(id: 99))
}
```

### Test Pop to Route with Associated Value

```swift
@Test("Pop to route with associated value")
func popToRouteWithAssociatedValue() {
    let router = Router<MockRoute>()

    router.navigate(to: .home)
    router.navigate(to: .detail(id: 42))
    router.navigate(to: .profile)

    router.popTo(.detail(id: 42))

    #expect(router.count == 2)
    #expect(router.currentRoutes.last == .detail(id: 42))
}
```

## Testing Complex Flows

### Test Complete Navigation Flow

```swift
@Test("Complete navigation flow")
func completeNavigationFlow() {
    let router = Router<MockRoute>()

    // Navigate forward
    router.navigate(to: .home)
    router.navigate(to: .profile)
    router.navigate(to: .detail(id: 1))
    #expect(router.count == 3)

    // Pop once
    router.pop()
    #expect(router.count == 2)
    #expect(router.currentRoutes.last == .profile)

    // Navigate to different screen
    router.navigate(to: .settings)
    #expect(router.count == 3)

    // Pop to specific route
    router.popTo(.home)
    #expect(router.count == 1)

    // Pop to root
    router.popToRoot()
    #expect(router.isEmpty)
}
```

### Test Multi-Step Onboarding Flow

```swift
@Test("Onboarding flow executes correctly")
func onboardingFlow() {
    let router = Router<MockRoute>()

    // Step 1: Start
    router.navigate(to: .onboardingWelcome)
    #expect(router.count == 1)

    // Step 2: Profile setup
    router.navigate(to: .onboardingProfile)
    #expect(router.count == 2)

    // Step 3: Preferences
    router.navigate(to: .onboardingPreferences)
    #expect(router.count == 3)

    // Complete: Clear and go to home
    router.popToRoot()
    router.navigate(to: .home)
    #expect(router.count == 1)
    #expect(router.currentRoutes == [.home])
}
```

## Testing ViewModels with Navigation

### Mock Router for ViewModel Testing

```swift
@Test("ViewModel navigates correctly")
func viewModelNavigation() {
    let router = Router<MockRoute>()
    let viewModel = ProfileViewModel(router: router)

    viewModel.openSettings()

    #expect(router.count == 1)
    #expect(router.currentRoutes == [.settings])
}

@Test("ViewModel validates before navigation")
func viewModelValidation() {
    let router = Router<MockRoute>()
    let viewModel = DetailViewModel(router: router)

    // Invalid ID should not navigate
    viewModel.openDetail(id: -1)
    #expect(router.isEmpty)

    // Valid ID should navigate
    viewModel.openDetail(id: 42)
    #expect(router.count == 1)
    #expect(router.currentRoutes == [.detail(id: 42)])
}
```

### Example ViewModel for Testing

```swift
@Observable
final class ProfileViewModel {
    private let router: Router<MockRoute>

    init(router: Router<MockRoute>) {
        self.router = router
    }

    func openSettings() {
        router.navigate(to: .settings)
    }
}

@Observable
final class DetailViewModel {
    private let router: Router<MockRoute>

    init(router: Router<MockRoute>) {
        self.router = router
    }

    func openDetail(id: Int) {
        guard id > 0 else { return }
        router.navigate(to: .detail(id: id))
    }
}
```

## Test Organization

### Using Test Suites

```swift
@Suite("Router Basic Operations")
struct RouterBasicTests {
    @Test("Router starts empty")
    func startsEmpty() {
        let router = Router<MockRoute>()
        #expect(router.isEmpty)
    }

    @Test("Navigate adds route")
    func navigateAdds() {
        let router = Router<MockRoute>()
        router.navigate(to: .home)
        #expect(router.count == 1)
    }
}

@Suite("Router Pop Operations")
struct RouterPopTests {
    @Test("Pop removes last route")
    func popRemoves() {
        let router = Router<MockRoute>()
        router.navigate(to: .home)
        router.navigate(to: .profile)
        router.pop()
        #expect(router.count == 1)
    }

    @Test("Pop to root clears stack")
    func popToRootClears() {
        let router = Router<MockRoute>()
        router.navigate(to: .home)
        router.navigate(to: .profile)
        router.popToRoot()
        #expect(router.isEmpty)
    }
}
```

## Best Practices

### 1. Test Edge Cases

Always test boundary conditions:
- Empty stack operations
- Non-existent routes
- Invalid parameters

### 2. Use Descriptive Test Names

```swift
// Good: Clear intent
@Test("Pop on empty stack does not crash")

// Avoid: Vague
@Test("Test pop")
```

### 3. Keep Tests Focused

Each test should verify one specific behavior:

```swift
// Good: Single responsibility
@Test("Navigate adds route to stack")
func navigateAdds() {
    let router = Router<MockRoute>()
    router.navigate(to: .home)
    #expect(router.count == 1)
}

// Avoid: Testing multiple things
@Test("Navigation works")
func navigationWorks() {
    let router = Router<MockRoute>()
    router.navigate(to: .home)
    router.pop()
    router.popToRoot()
    // Too much in one test
}
```

### 4. Test Realistic Scenarios

Create tests that mirror actual user flows:

```swift
@Test("User checkout flow")
func checkoutFlow() {
    let router = Router<MockRoute>()

    router.navigate(to: .cart)
    router.navigate(to: .checkout)
    router.navigate(to: .payment)
    router.navigate(to: .confirmation)

    #expect(router.count == 4)

    // User completes and returns home
    router.popToRoot()
    router.navigate(to: .home)

    #expect(router.currentRoutes == [.home])
}
```

## Running Tests

### In Xcode

1. Press `Cmd + U` to run all tests
2. Use the Test Navigator (Cmd + 6) to run specific tests
3. View test results in the Test Navigator

### From Command Line

```bash
swift test
```

## Continuous Integration

ARCNavigation tests are fast and don't require UI, making them perfect for CI:

```yaml
# GitHub Actions example
- name: Run Tests
  run: swift test
```

## Next Steps

- Review <doc:GettingStarted> for basic navigation setup
- Explore <doc:AdvancedUsage> for complex patterns
- Understand the <doc:Architecture> behind the testing approach
