//
//  SettingsView.swift
//  ARCNavigationDemo
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI
import ARCNavigation

struct SettingsView: View {

    // MARK: - Properties

    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        Form {
            Section("Actions") {
                Button("Go to Profile") {
                    router.navigate(to: .profile(userName: "Bob"))
                }

                Button("Go to Detail") {
                    router.navigate(to: .detail(id: 99))
                }
            }

            Section("Navigation") {
                Button("Pop") {
                    router.pop()
                }

                Button("Pop to Root") {
                    router.popToRoot()
                }
            }

            Section("Stack Debug") {
                Text("Current routes: \(router.count)")
                ForEach(Array(router.currentRoutes.enumerated()), id: \.offset) { index, route in
                    Text("[\(index)] \(String(describing: route))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
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
