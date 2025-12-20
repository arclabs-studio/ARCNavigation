# Changelog

All notable changes to ARCNavigation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- ARCDevTools integration with SwiftLint and SwiftFormat configurations
- Documentation.docc catalog for API documentation
- GitHub Actions CI/CD workflow

### Changed
- Refactored `withRouter` to use `@Bindable` wrapper for Swift 6 strict concurrency compliance

## [1.0.0] - 2025-01-01

### Added
- Initial release of ARCNavigation
- `Route` protocol for type-safe route definitions
- `Router<R>` class with `@Observable` for navigation state management
- Core navigation methods: `navigate(to:)`, `pop()`, `popToRoot()`, `popTo(_:)`
- `withRouter(_:destination:)` View extension for NavigationStack integration
- Testing helpers: `currentRoutes`, `isEmpty`, `count` properties
- Comprehensive test suite with Swift Testing framework
- Support for routes with associated values
- Zero external dependencies
- Swift 6 ready with strict concurrency

### Platforms
- iOS 17.0+
- macOS 14.0+
- tvOS 17.0+
- watchOS 10.0+
