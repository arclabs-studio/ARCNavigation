# Getting Started with ARCNavigation

Learn how to integrate ARCNavigation into your SwiftUI app and implement basic navigation flows.

## Overview

ARCNavigation makes navigation in SwiftUI apps simple and type-safe. This guide will walk you through setting up the package and creating your first navigation flow.

## Installation

### Swift Package Manager

Add ARCNavigation to your project using Xcode:

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies**
3. Enter the package URL: `https://github.com/arclabs-studio/ARCNavigation`
4. Select the version and add to your target

Alternatively, add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCNavigation", from: "1.0.0")
]
```

## Basic Setup

### Step 1: Define Your Routes

Create an enum that conforms to the ``Route`` protocol. Each case represents a screen in your app:

```swift
import ARCNavigation
import SwiftUI

enum AppRoute: Route {
    case home
    case profile(userID: String)
    case settings
    case detail(id: Int)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .profile(let userID):
            ProfileView(userID: userID)
        case .settings:
            SettingsView()
        case .detail(let id):
            DetailView(id: id)
        }
    }
}
```

> Tip: Use associated values to pass data between screens in a type-safe way.

### Step 2: Initialize the Router

Create a ``Router`` instance in your app's entry point:

```swift
import SwiftUI
import ARCNavigation

@main
struct MyApp: App {
    @State private var router = Router<AppRoute>()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .withRouter(router) { route in
                    route.view()
                }
        }
    }
}
```

The `withRouter(_:destination:)` modifier sets up the navigation infrastructure and makes the router available via the environment.

### Step 3: Navigate from Your Views

Access the router in your views using the `@Environment` property wrapper:

```swift
import SwiftUI
import ARCNavigation

struct HomeView: View {
    @Environment(Router<AppRoute>.self) private var router

    var body: some View {
        VStack(spacing: 20) {
            Text("Home Screen")
                .font(.largeTitle)

            Button("Go to Profile") {
                router.navigate(to: .profile(userID: "123"))
            }
            .buttonStyle(.borderedProminent)

            Button("Go to Settings") {
                router.navigate(to: .settings)
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("Home")
    }
}
```

## Navigation Basics

### Navigating Forward

Use ``Router/navigate(to:)`` to push a new screen:

```swift
router.navigate(to: .profile(userID: "user123"))
```

### Going Back

Use ``Router/pop()`` to go back one screen:

```swift
router.pop()
```

### Returning to Root

Use ``Router/popToRoot()`` to dismiss all screens and return to the root:

```swift
router.popToRoot()
```

### Navigating to a Specific Screen

Use ``Router/popTo(_:)`` to go back to a specific screen in the navigation stack:

```swift
router.popTo(.home)
```

## Example: Complete Flow

Here's a complete example showing navigation between multiple screens:

```swift
// ProfileView.swift
struct ProfileView: View {
    let userID: String
    @Environment(Router<AppRoute>.self) private var router

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile: \(userID)")
                .font(.title)

            Button("View Details") {
                router.navigate(to: .detail(id: 42))
            }

            Button("Go to Settings") {
                router.navigate(to: .settings)
            }

            Divider()

            Button("Back") {
                router.pop()
            }

            Button("Home") {
                router.popToRoot()
            }
        }
        .navigationTitle("Profile")
    }
}
```

## Next Steps

- Learn about <doc:AdvancedUsage> including MVVM integration and complex flows
- Explore <doc:TestingGuide> to test your navigation logic
- Understand the <doc:Architecture> behind ARCNavigation
