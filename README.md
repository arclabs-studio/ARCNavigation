# ARCNavigation

A type-safe, testable SwiftUI navigation system for modern iOS apps.

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platform](https://img.shields.io/badge/platforms-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20tvOS%2017%2B%20%7C%20watchOS%2010%2B-blue.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)
![Xcode](https://img.shields.io/badge/Xcode-16%2B-blue.svg)
![CI](https://github.com/arclabs-studio/ARCNavigation/actions/workflows/ci.yml/badge.svg)

---

## Overview

ARCNavigation provides a clean, Router-based navigation pattern for SwiftUI applications. It leverages Swift's type system to ensure compile-time safety for all navigation flows, while remaining fully testable without UI dependencies.

Built with Swift 6 and strict concurrency compliance, ARCNavigation integrates seamlessly with modern SwiftUI apps using `@Observable` and `NavigationStack`.

## Features

- Type-safe navigation with enum-based routes
- Fully testable with Swift Testing
- Clean separation of concerns
- Support for complex navigation flows
- Zero dependencies
- Swift 6 ready with strict concurrency

## Requirements

- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+
- Swift 6.0+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add ARCNavigation to your project via Xcode:

1. File > Add Package Dependencies
2. Enter package URL: `https://github.com/arclabs-studio/ARCNavigation`
3. Select version

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCNavigation", from: "1.0.0")
]
```

## Usage

### 1. Define Your Routes

Create an enum conforming to the `Route` protocol:

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
        case .profile(let id):
            ProfileView(userID: id)
        case .settings:
            SettingsView()
        }
    }
}
```

### 2. Setup Router in Your App

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

### 3. Navigate from Your Views

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

### Navigation API

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

| Component | Description |
|-----------|-------------|
| **Router** | Centralized navigation manager using `@Observable` |
| **Route** | Protocol-based route definition with enum cases |
| **Type-Safety** | Full compile-time safety with associated values |
| **Testing** | Built-in support for unit testing navigation flows |

## Roadmap

- [ ] Deep linking support
- [ ] Analytics integration
- [ ] Custom transitions
- [ ] URL-based navigation

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes following [Conventional Commits](https://www.conventionalcommits.org/)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code:
- Passes all tests (`swift test`)
- Passes SwiftLint (`swiftlint lint`)
- Includes appropriate documentation
- Follows the existing code style

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 ARC Labs Studio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Author

**ARC Labs Studio** - iOS Development

- GitHub: [@arclabs-studio](https://github.com/arclabs-studio)
