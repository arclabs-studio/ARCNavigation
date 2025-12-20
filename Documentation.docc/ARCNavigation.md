# ``ARCNavigation``

A type-safe, testable SwiftUI navigation system for modern iOS apps.

## Overview

ARCNavigation provides a clean, type-safe approach to navigation in SwiftUI applications. Built with Swift 6 and strict concurrency in mind, it offers a Router-based pattern that makes navigation flows easy to test and maintain.

### Key Features

- **Type-Safe Routes**: Define your navigation destinations as enum cases with associated values
- **Observable State**: Uses `@Observable` for efficient SwiftUI integration
- **Fully Testable**: Test navigation flows without UI, using simple assertions
- **Zero Dependencies**: No external dependencies, just pure Swift and SwiftUI
- **Swift 6 Ready**: Built with strict concurrency compliance

## Topics

### Essentials

- <doc:GettingStarted>
- ``Route``
- ``Router``

### Navigation

- ``Router/navigate(to:)``
- ``Router/pop()``
- ``Router/popToRoot()``
- ``Router/popTo(_:)``

### Testing

- ``Router/currentRoutes``
- ``Router/isEmpty``
- ``Router/count``
