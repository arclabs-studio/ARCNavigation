# ARCNavigation

A type-safe, testable SwiftUI navigation system for modern iOS apps.

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platform](https://img.shields.io/badge/platforms-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20tvOS%2017%2B%20%7C%20watchOS%2010%2B-blue.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)
![Xcode](https://img.shields.io/badge/Xcode-16%2B-blue.svg)

---

## Features

- ✅ Type-safe navigation with enum-based routes
- ✅ Fully testable with Swift Testing
- ✅ Clean separation of concerns
- ✅ Support for complex navigation flows
- ✅ Zero dependencies
- ✅ Swift 6 ready with strict concurrency

## Requirements

- iOS 17.0+
- Swift 6.0+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add ARCNavigation to your project via Xcode:

1. File → Add Package Dependencies
2. Enter package URL: `https://github.com/arclabs-studio/ARCNavigation`
3. Select version

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCNavigation", from: "1.0.0")
]
```

## Quick Start

### 1. Define your routes

```swift
import ARCNavigation

enum AppRoute: Route {
    case home
    case profile(userID: String)
    case settings

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .profile(let id):
            ProfileView(userID: id)
        case .settings:
            SettingsView()
        }
    }
}
```

### 2. Setup router in your app

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

### 3. Navigate from your views

```swift
import SwiftUI
import ARCNavigation

struct ContentView: View {
    @Environment(Router<AppRoute>.self) private var router

    var body: some View {
        Button("Go to Profile") {
            router.navigate(to: .profile(userID: "123"))
        }
    }
}
```

## Navigation API

```swift
// Navigate forward
router.navigate(to: .profile(userID: "123"))

// Go back one screen
router.pop()

// Go back to root
router.popToRoot()

// Go back to specific route
router.popTo(.home)

// Check stack state
let isEmpty = router.isEmpty
let count = router.count
let routes = router.currentRoutes
```

## Testing

ARCNavigation is fully testable with Swift Testing:

```swift
import Testing
@testable import ARCNavigation

@Test func navigationFlow() {
    let router = Router<AppRoute>()

    router.navigate(to: .profile(userID: "123"))
    #expect(router.count == 1)

    router.pop()
    #expect(router.isEmpty)
}
```

## Demo App

Check the `Examples/ARCNavigationDemo` folder for a complete working example with:
- 4 sample screens demonstrating different navigation patterns
- Dark and light mode previews
- MVVM architecture example

## Architecture

ARCNavigation follows a simple and scalable architecture:

- **Router**: Centralized navigation manager using `@Observable`
- **Route**: Protocol-based route definition with enum cases
- **Type-Safety**: Full compile-time safety with associated values
- **Testing**: Built-in support for unit testing navigation flows

## Roadmap

- [ ] Deep linking support
- [ ] Analytics integration
- [ ] Custom transitions
- [ ] URL-based navigation

## License

MIT License - see LICENSE file for details

## Author

**ARC Labs Studio** - iOS Development

Built with ❤️ for the indie iOS developer community
