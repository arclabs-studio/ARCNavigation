# Getting Started with ARCNavigation

Learn how to integrate ARCNavigation into your SwiftUI app and implement type-safe navigation.

## Overview

ARCNavigation simplifies SwiftUI navigation by providing a type-safe Router pattern. This guide walks you through the basic setup and common navigation patterns.

## Define Your Routes

Start by creating an enum that conforms to the ``Route`` protocol. Each case represents a destination in your app:

```swift
import ARCNavigation
import SwiftUI

enum AppRoute: Route {
    case home
    case profile(userID: String)
    case settings

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .profile(let userID):
            ProfileView(userID: userID)
        case .settings:
            SettingsView()
        }
    }
}
```

## Setup the Router

Create a ``Router`` instance in your App struct and apply it to your root view:

```swift
import SwiftUI
import ARCNavigation

@main
struct MyApp: App {
    @State private var router = Router<AppRoute>()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .withRouter(router) { $0.view() }
        }
    }
}
```

## Navigate from Views

Access the router from any view using the `@Environment` property wrapper:

```swift
struct ContentView: View {
    @Environment(Router<AppRoute>.self) private var router

    var body: some View {
        VStack {
            Button("Go to Profile") {
                router.navigate(to: .profile(userID: "123"))
            }

            Button("Go to Settings") {
                router.navigate(to: .settings)
            }
        }
    }
}
```

## Navigation Methods

ARCNavigation provides several navigation methods:

| Method | Description |
|--------|-------------|
| `navigate(to:)` | Push a new route onto the stack |
| `pop()` | Go back one screen |
| `popToRoot()` | Go back to the root screen |
| `popTo(_:)` | Go back to a specific route |

## Testing Navigation

One of the key benefits of ARCNavigation is testability. You can test navigation flows without any UI:

```swift
import Testing
@testable import ARCNavigation

@Test func navigationFlow() {
    let router = Router<AppRoute>()

    router.navigate(to: .profile(userID: "123"))
    #expect(router.count == 1)
    #expect(!router.isEmpty)

    router.pop()
    #expect(router.isEmpty)
}
```

## Next Steps

- Explore the ``Router`` class for all available properties and methods
- Check out the Example app in the repository for more complex patterns
- Learn about deep linking integration (coming soon)
