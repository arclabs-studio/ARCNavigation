# 🧭 ARCNavigation

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20tvOS%2017%2B%20%7C%20watchOS%2010%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)

**A type-safe, testable SwiftUI navigation system for modern iOS apps.**

Type-Safe Routes • Observable State • Fully Testable • Built-in Logging • Swift 6 Ready

---

## 🎯 Overview

ARCNavigation provides a clean, Router-based navigation pattern for SwiftUI applications. It leverages Swift's type system to ensure compile-time safety for all navigation flows, while remaining fully testable without UI dependencies.

Built with Swift 6 and strict concurrency compliance, ARCNavigation integrates seamlessly with modern SwiftUI apps using `@Observable` and `NavigationStack`.

### Key Features

- ✅ **Type-Safe Navigation** - Define routes as enum cases with associated values
- ✅ **Tab Navigation** - Per-tab navigation stacks with `TabRouter` and `NavigationTab`
- ✅ **Coordinator Pattern** - Centralized route-to-view mapping with `Coordinator` protocol
- ✅ **Observable State** - Uses `@Observable` for efficient SwiftUI integration
- ✅ **Fully Testable** - Test navigation flows without UI, using simple assertions
- ✅ **Built-in Logging** - Optional structured logging via ARCLogger
- ✅ **Swift 6 Ready** - Built with strict concurrency compliance

---

## 📋 Requirements

- **Swift:** 6.0+
- **Platforms:** iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+
- **Xcode:** 16.0+

---

## 🚀 Installation

### Swift Package Manager

#### For Swift Packages

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCNavigation", from: "1.0.0")
]
```

#### For Xcode Projects

1. **File → Add Package Dependencies**
2. Enter: `https://github.com/arclabs-studio/ARCNavigation`
3. Select version: `1.0.0` or later

---

## 📖 Usage

### Quick Start

```swift
import ARCNavigation
import SwiftUI

// 1. Define your routes
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

// 2. Setup in your App
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

// 3. Navigate from views
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

### Tab Navigation

For apps with a `TabView`, use `TabRouter` to manage independent navigation stacks per tab:

```swift
import ARCNavigation

// 1. Define your tabs
enum AppTab: String, NavigationTab {
    case home, explore, settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .explore: "Explore"
        case .settings: "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: "house"
        case .explore: "magnifyingglass"
        case .settings: "gearshape"
        }
    }
}

// 2. Create a TabRouter
@State private var tabRouter = TabRouter<AppTab, AppRoute>()

// 3. Use with TabView
TabView(selection: tabRouter.activeTabBinding) {
    ForEach(AppTab.allCases) { tab in
        ContentView()
            .withTabNavigation(tabRouter, for: tab) { $0.view() }
            .tabItem { Label(tab.title, systemImage: tab.icon) }
            .tag(tab)
    }
}
```

### Coordinator Pattern

For more complex apps, use `TabCoordinator` to centralize view creation:

```swift
@Observable
@MainActor
final class AppCoordinator: TabCoordinator {
    let tabRouter = TabRouter<AppTab, AppRoute>()

    @ViewBuilder
    func makeView(for route: AppRoute) -> some View {
        route.view()
    }
}
```

### Logging

Enable optional logging to debug navigation flows:

```swift
// Enable logging when creating the router
@State private var router = Router<AppRoute>(loggingEnabled: true)

// Or toggle at runtime
router.loggingEnabled = true
```

When enabled, the router logs navigation events with structured metadata:
- Navigation pushes and pops
- Stack size changes
- Warnings for edge cases (e.g., pop on empty stack)

---

## 🏗️ Project Structure

```
ARCNavigation/
├── Sources/
│   └── ARCNavigation/
│       ├── Route.swift            # Protocol for type-safe route definitions
│       ├── Router.swift           # @Observable navigation manager
│       ├── NavigationTab.swift    # Protocol for tab definitions
│       ├── TabRouter.swift        # Per-tab navigation manager
│       ├── Coordinator.swift      # Coordinator and TabCoordinator protocols
│       ├── View+Router.swift      # SwiftUI View extension (.withRouter)
│       └── View+TabRouter.swift   # SwiftUI View extension (.withTabNavigation)
├── Tests/
│   └── ARCNavigationTests/
│       ├── RouterTests.swift      # Router tests
│       ├── TabRouterTests.swift   # TabRouter tests
│       └── CoordinatorTests.swift # Coordinator tests
├── Example/
│   └── ExampleApp/                # Standalone demo Xcode project
└── Documentation.docc/            # DocC documentation
```

---

## 🧪 Testing

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

### Running Tests

```bash
swift test
```

### Coverage

- **Target:** 100%
- **Minimum:** 80%

---

## 📐 Architecture

ARCNavigation follows a simple and scalable architecture:

| Component | Description |
|-----------|-------------|
| **Route** | Protocol defining routes with `Hashable` conformance and `view()` method |
| **Router** | `@Observable` class managing `NavigationPath` and route tracking |
| **NavigationTab** | Protocol for defining tabs with title, icon, and optional badge |
| **TabRouter** | `@Observable` class managing per-tab `Router` instances |
| **Coordinator** | Protocol for centralized route-to-view mapping |
| **TabCoordinator** | Coordinator with `TabRouter` and default navigation methods |
| **View Extensions** | `.withRouter()` and `.withTabNavigation()` for `NavigationStack` integration |

For complete architecture guidelines, see [ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge).

---

## 🛠️ Development

### Prerequisites

```bash
# Install required tools
brew install swiftlint swiftformat
```

### Setup

```bash
# Clone the repository
git clone https://github.com/arclabs-studio/ARCNavigation.git
cd ARCNavigation

# Update submodules
git submodule update --init --recursive

# Build the project
swift build
```

### Available Commands

```bash
make help          # Show all available commands
make lint          # Run SwiftLint
make format        # Preview formatting changes
make fix           # Apply SwiftFormat
make test          # Run tests
make clean         # Remove build artifacts
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `feature/your-feature`
3. Follow [ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge) standards
4. Ensure tests pass: `swift test`
5. Run quality checks: `make lint && make format`
6. Create a pull request

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add deep linking support
fix: resolve crash on popToRoot
docs: update installation instructions
```

---

## 📦 Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** - Breaking changes
- **MINOR** - New features (backwards compatible)
- **PATCH** - Bug fixes (backwards compatible)

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🔗 Related Resources

- **[ARCLogger](https://github.com/arclabs-studio/ARCLogger)** - Privacy-conscious structured logging
- **[ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge)** - Development standards and guidelines
- **[ARCDevTools](https://github.com/arclabs-studio/ARCDevTools)** - Quality tooling and automation

---

<div align="center">

Made with 💛 by ARC Labs Studio

[**GitHub**](https://github.com/arclabs-studio) • [**Issues**](https://github.com/arclabs-studio/ARCNavigation/issues)

</div>
