# Changelog

All notable changes to ARCNavigation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-20

First public release of **ARCNavigation**.

ARC Labs Studio re-baselined every package at `1.0.0` for its first product launch. The pre-launch version history (1.0.0 → 1.1.0) never corresponded to a release the studio stood behind; those tags and GitHub Releases have been removed and the notes are preserved below under [Pre-1.0 history](#pre-10-history-untagged).

### Added

- **`INTERNAL-USE.md`** — documents ARC Labs Studio's self-grant for commercial use of its own products under the new licence.

- `NavigationTab` protocol for defining tabs with title, icon, and badge
- `TabRouter` class for managing per-tab navigation stacks with search context
- `Coordinator` protocol for centralized route-to-view mapping
- `TabCoordinator` protocol with default navigation methods via `TabRouter`
- `.withTabNavigation(_:for:destination:)` view extension for tab-based `NavigationStack`
- `Route` default implementation returning `EmptyView` for coordinator-based routes
- `TabRouter.activeTabBinding` for `TabView(selection:)` integration
- `TabRouter.resetAll()` to clear all navigation stacks
- Example app updated with tab-based navigation using `AppTab`, `AppCoordinator`, and `MainTabView`

### Changed

- **License** — relicensed from MIT to [PolyForm Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0). Source-available and free for non-commercial use; commercial use requires a separate licence from ARC Labs Studio. ARC Labs Studio's own products are covered by an internal grant — see `INTERNAL-USE.md`.

---

## Pre-1.0 history (untagged)

Everything below predates the 1.0.0 baseline. The version numbers are retained for traceability only — no tag or release exists for any of them.

### [1.1.0] - 2026-01-13

#### Added
- ARCDevTools integration with SwiftLint and SwiftFormat configurations
- Documentation.docc catalog for API documentation
- GitHub Actions CI/CD workflow
- ARCLogger integration for optional navigation logging
- `loggingEnabled` property in `Router` to enable/disable logging
- Structured logging with metadata for navigation events

#### Changed
- Refactored `withRouter` to use `@Bindable` wrapper for Swift 6 strict concurrency compliance
- Updated ARCDevTools submodule to v1.6.0

---

### [1.0.0] - 2025-01-01

#### Added
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

#### Platforms
- iOS 17.0+
- macOS 14.0+
- tvOS 17.0+
- watchOS 10.0+

---

[1.0.0]: https://github.com/arclabs-studio/ARCNavigation/releases/tag/v1.0.0
