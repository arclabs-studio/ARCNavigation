//
//  ProfileView.swift
//  ARCNavigationDemo
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI
import ARCNavigation

struct ProfileView: View {

    // MARK: - Properties

    let userName: String
    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile: \(userName)")
                .font(.largeTitle)

            Button("Go to Settings") {
                router.navigate(to: .settings)
            }
            .buttonStyle(.borderedProminent)

            Button("Go to Detail") {
                router.navigate(to: .detail(id: 42))
            }
            .buttonStyle(.bordered)

            Divider()

            Button("Pop") {
                router.pop()
            }
            .buttonStyle(.bordered)

            Button("Pop to Root") {
                router.popToRoot()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Profile")
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ProfileView(userName: "Alice")
    }
    .environment(Router<AppRoute>())
}

#Preview("Dark Mode") {
    NavigationStack {
        ProfileView(userName: "Alice")
    }
    .environment(Router<AppRoute>())
    .preferredColorScheme(.dark)
}
