//
//  HomeView.swift
//  ARCNavigationDemo
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI
import ARCNavigation

struct HomeView: View {

    // MARK: - Properties

    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        List {
            Section("Navigation Examples") {
                Button("Go to Profile") {
                    router.navigate(to: .profile(userName: "Alice"))
                }

                Button("Go to Settings") {
                    router.navigate(to: .settings)
                }

                Button("Go to Detail #1") {
                    router.navigate(to: .detail(id: 1))
                }
            }

            Section("Stack Info") {
                Text("Current stack size: \(router.count)")
                Text("Is empty: \(router.isEmpty ? "Yes" : "No")")
            }
        }
        .navigationTitle("ARCNavigation Demo")
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        HomeView()
    }
    .environment(Router<AppRoute>())
}

#Preview("Dark Mode") {
    NavigationStack {
        HomeView()
    }
    .environment(Router<AppRoute>())
    .preferredColorScheme(.dark)
}
