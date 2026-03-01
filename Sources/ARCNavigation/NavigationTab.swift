//
//  NavigationTab.swift
//  ARCNavigation
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import Foundation

/// A protocol that defines a tab in a tab-based navigation system.
///
/// Conform to this protocol to define the tabs available in your app.
/// Each tab has a title, icon, and optional badge count.
///
/// ## Overview
///
/// Implement this protocol as an enum where each case represents a tab
/// in your app's `TabView`. The protocol requires `CaseIterable` so
/// ``TabRouter`` can enumerate all available tabs.
///
/// ## Example
///
/// ```swift
/// enum AppTab: String, NavigationTab {
///     case home
///     case explore
///     case settings
///
///     var id: String { rawValue }
///
///     var title: String {
///         switch self {
///         case .home: "Home"
///         case .explore: "Explore"
///         case .settings: "Settings"
///         }
///     }
///
///     var icon: String {
///         switch self {
///         case .home: "house"
///         case .explore: "magnifyingglass"
///         case .settings: "gearshape"
///         }
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Tab Properties
/// - ``title``
/// - ``icon``
/// - ``badge``
@MainActor public protocol NavigationTab: Hashable, Identifiable, CaseIterable
where AllCases: RandomAccessCollection {
    /// The display title for this tab.
    var title: String { get }

    /// The SF Symbol name for this tab's icon.
    var icon: String { get }

    /// An optional badge count displayed on the tab.
    ///
    /// Returns `nil` by default, meaning no badge is shown.
    var badge: Int? { get }
}

// MARK: - Default Implementations

extension NavigationTab {
    /// Default implementation returning `nil` (no badge).
    public var badge: Int? {
        nil
    }
}
