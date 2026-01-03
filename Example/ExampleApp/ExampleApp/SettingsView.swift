//
//  SettingsView.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import ARCNavigation
import SwiftUI

/// Settings screen demonstrating stack inspection.
struct SettingsView: View {

    // MARK: - Properties

    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        Form {
            actionsSection
            navigationSection
            debugSection
        }
        .navigationTitle("Settings")
    }

    // MARK: - Sections

    private var actionsSection: some View {
        Section("Navigate Forward") {
            Button("Go to Profile (Bob)") {
                router.navigate(to: .profile(user: .bob))
            }

            Button("Go to Detail #99") {
                router.navigate(to: .detail(id: 99))
            }
        }
    }

    private var navigationSection: some View {
        Section("Pop Actions") {
            Button("Pop (Go Back)") {
                router.pop()
            }

            Button("Pop to Root") {
                router.popToRoot()
            }
            .foregroundStyle(.red)
        }
    }

    private var debugSection: some View {
        Section("Stack Debug (currentRoutes)") {
            LabeledContent("Routes Count", value: "\(router.count)")

            if router.currentRoutes.isEmpty {
                Text("Stack is empty")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(router.currentRoutes.enumerated()), id: \.offset) { index, route in
                    HStack {
                        Text("[\(index)]")
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                        Text(routeDescription(for: route))
                            .font(.caption)
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func routeDescription(for route: AppRoute) -> String {
        switch route {
        case .home:
            return "home"
        case .profile(let user):
            return "profile(\(user.name))"
        case .settings:
            return "settings"
        case .detail(let id):
            return "detail(\(id))"
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        SettingsView()
    }
    .environment(Router<AppRoute>())
}

#Preview("Dark Mode") {
    NavigationStack {
        SettingsView()
    }
    .environment(Router<AppRoute>())
    .preferredColorScheme(.dark)
}
