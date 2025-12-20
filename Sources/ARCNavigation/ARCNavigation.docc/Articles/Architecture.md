# Architecture

Understand the design principles and implementation details of ARCNavigation.

## Overview

ARCNavigation is built on three core principles: simplicity, type-safety, and testability. This document explains the architectural decisions, design patterns, and implementation details that make ARCNavigation both powerful and easy to use.

## Design Philosophy

### 1. Simplicity First

ARCNavigation provides a minimal API surface:
- Three navigation operations: `navigate()`, `pop()`, `popToRoot()`, `popTo()`
- One setup method: `withRouter(_:destination:)`
- Two core types: ``Router`` and ``Route``

### 2. Type-Safety

Swift's type system ensures navigation is safe:
- Enum-based routes eliminate typos and invalid routes
- Associated values provide compile-time parameter checking
- Generic `Router<R: Route>` ties navigation to your route definitions

### 3. Testability

ARCNavigation separates navigation logic from UI:
- Router operates independently of SwiftUI views
- Navigation state is fully inspectable
- No UI required for testing navigation flows

## Core Components

### Router

The ``Router`` is the central coordinator for navigation.

#### Implementation Details

```swift
@Observable
public final class Router<R: Route> {
    public var path = NavigationPath()
    private var routes: [R] = []

    // ...
}
```

**Key Design Decisions:**

1. **`@Observable` Macro**: Uses Swift's Observation framework for reactive updates
2. **Generic over Route**: Type-safe binding to your route enum
3. **Dual State Tracking**:
   - `path`: SwiftUI's `NavigationPath` for UI integration
   - `routes`: Array for type-safe inspection and testing

#### State Synchronization

The router maintains two synchronized representations:

```swift
public func navigate(to route: R) {
    routes.append(route)      // Type-safe array
    path.append(route)         // SwiftUI's NavigationPath
}
```

This dual approach provides:
- Type-safe access via `currentRoutes`
- SwiftUI integration via `path`
- Zero performance overhead (append is O(1))

### Route Protocol

The ``Route`` protocol defines your navigation graph.

```swift
public protocol Route: Hashable {
    associatedtype Destination: View
    @ViewBuilder func view() -> Destination
}
```

**Why This Design:**

1. **Hashable**: Required by `NavigationPath` for identifying destinations
2. **Associated Type**: Allows different view types per route
3. **ViewBuilder**: Enables flexible view composition

#### Type Erasure Pattern

SwiftUI's `NavigationPath` uses type erasure internally. ARCNavigation bridges this by:

1. Routes conform to `Hashable` for NavigationPath compatibility
2. Router maintains typed array for type-safe access
3. `withRouter` connects both worlds

### View Extension

The `withRouter(_:destination:)` modifier sets up navigation infrastructure.

#### How It Works

```swift
public extension View {
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
```

**This Method:**

1. Creates a `NavigationStack` bound to the router's path
2. Registers route-to-view mapping via `navigationDestination`
3. Injects router into environment for child views

## Architecture Patterns

### MVVM Integration

ARCNavigation fits naturally into MVVM architecture:

```
┌─────────────────────────────────────────┐
│              View                       │
│  - Displays UI                          │
│  - Handles user input                   │
│  - @Environment(Router)                 │
└──────────────┬──────────────────────────┘
               │ calls
               ▼
┌─────────────────────────────────────────┐
│           ViewModel                     │
│  - Business logic                       │
│  - Navigation decisions                 │
│  - Holds Router reference               │
└──────────────┬──────────────────────────┘
               │ uses
               ▼
┌─────────────────────────────────────────┐
│            Router                       │
│  - Manages navigation stack             │
│  - Type-safe operations                 │
└─────────────────────────────────────────┘
```

### Coordinator Pattern (Lightweight)

ARCNavigation implements a lightweight coordinator pattern:

- **Coordinator**: `Router<YourRoute>`
- **Routes**: Enum defining navigation graph
- **Views**: Decoupled from navigation logic

Unlike traditional coordinators, ARCNavigation doesn't require:
- Protocol hierarchies
- Child coordinator management
- Complex lifecycle handling

### Unidirectional Data Flow

Navigation state flows in one direction:

```
User Action → ViewModel → Router → NavigationPath → SwiftUI
                                         │
                                         └→ routes array
                                              (for inspection)
```

## Implementation Details

### Memory Management

**Router Lifecycle:**
- Created once in app entry point
- Lives for app lifetime
- Lightweight (only tracks routes array)

**View Creation:**
- Views created lazily when navigated to
- SwiftUI handles view lifecycle
- No memory overhead from navigation system

### Thread Safety

ARCNavigation is designed for the main thread:
- `@Observable` ensures main-actor isolation
- Navigation operations must occur on main thread
- SwiftUI's NavigationStack requirement

### Performance Characteristics

| Operation | Time Complexity | Notes |
|-----------|----------------|-------|
| `navigate()` | O(1) | Array append |
| `pop()` | O(1) | Array removeLast |
| `popToRoot()` | O(n) | Remove n items |
| `popTo()` | O(n) | Linear search + remove |
| `currentRoutes` | O(1) | Direct array access |

Where n = number of routes in stack.

## Comparison with Alternatives

### vs. NavigationLink

**NavigationLink:**
- ❌ Tight view coupling
- ❌ Hard to test
- ✅ Native SwiftUI

**ARCNavigation:**
- ✅ Decoupled views
- ✅ Fully testable
- ✅ Built on NavigationStack

### vs. NavigationPath Alone

**NavigationPath:**
- ✅ SwiftUI native
- ❌ Type-erased (harder to inspect)
- ❌ No `popTo()` functionality

**ARCNavigation:**
- ✅ Type-safe inspection
- ✅ Additional operations
- ✅ Testable without UI

### vs. TCA (The Composable Architecture)

**TCA:**
- ✅ Comprehensive state management
- ❌ High learning curve
- ❌ Verbose boilerplate

**ARCNavigation:**
- ✅ Focused on navigation only
- ✅ Minimal learning curve
- ✅ Minimal boilerplate

### vs. Classic Coordinators

**Classic Coordinators:**
- ✅ Proven pattern
- ❌ UIKit-focused
- ❌ Complex setup

**ARCNavigation:**
- ✅ SwiftUI-native
- ✅ Simple setup
- ✅ Modern Swift features

## Future Extensibility

ARCNavigation's architecture supports future enhancements:

### Deep Linking (Planned)

The `routes` array can be serialized to/from URLs:

```swift
// Future API (not yet implemented)
extension Router {
    func navigate(url: URL) {
        let routes = URLParser.parse(url)
        // Reconstruct navigation stack
    }

    func currentURL() -> URL {
        return URLBuilder.build(from: routes)
    }
}
```

### Analytics Integration (Planned)

Navigation hooks for analytics:

```swift
// Future API (not yet implemented)
extension Router {
    var onNavigate: ((R) -> Void)?

    func navigate(to route: R) {
        onNavigate?(route)
        // ... existing implementation
    }
}
```

### Custom Transitions (Planned)

Support for custom navigation transitions:

```swift
// Future API (not yet implemented)
extension Router {
    func navigate(
        to route: R,
        transition: NavigationTransition = .default
    ) {
        // Apply custom transition
    }
}
```

## Design Constraints

ARCNavigation operates within these constraints:

1. **iOS 17+ Only**: Uses modern SwiftUI features
2. **NavigationStack Based**: Limited to push/pop navigation (no tabs/sheets)
3. **Main Thread**: All operations on main thread
4. **Swift 6**: Designed for strict concurrency

## Best Practices

### 1. Single Router per Navigation Hierarchy

```swift
// Good: One router for main navigation
@State private var router = Router<AppRoute>()

// Avoid: Multiple routers for same hierarchy
@State private var router1 = Router<AppRoute>()
@State private var router2 = Router<AppRoute>()
```

### 2. Enum for Routes

```swift
// Good: Exhaustive, type-safe
enum AppRoute: Route {
    case home
    case profile(userID: String)
}

// Avoid: Stringly-typed
struct Route {
    let name: String
    let params: [String: Any]
}
```

### 3. Dependency Injection

```swift
// Good: Inject router into ViewModels
class ViewModel {
    init(router: Router<AppRoute>) { }
}

// Avoid: Creating router in ViewModel
class ViewModel {
    let router = Router<AppRoute>() // Don't do this
}
```

## Debugging

### Inspecting Navigation State

Use the router's inspection API:

```swift
print("Stack depth: \(router.count)")
print("Current routes: \(router.currentRoutes)")
print("Is at root: \(router.isEmpty)")
```

### Common Issues

**Routes not appearing:**
- Ensure `withRouter` is applied to root view
- Check route's `view()` returns correct view

**State not updating:**
- Verify `@Environment(Router<AppRoute>.self)` is used
- Ensure router is created with `@State`

**Pop not working:**
- Confirm route exists in stack with `currentRoutes`
- Check for safe pop on empty stack

## Next Steps

- Start with <doc:GettingStarted> to implement ARCNavigation
- Explore <doc:AdvancedUsage> for complex scenarios
- Review <doc:TestingGuide> for testing strategies
