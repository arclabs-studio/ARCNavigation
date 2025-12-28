//
//  ProfileView.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import ARCNavigation
import SwiftUI

/// Profile screen demonstrating navigation with associated values.
struct ProfileView: View {

    // MARK: - Properties

    let user: User
    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {
            profileHeader
            navigationActions
            Spacer()
            popActions
        }
        .padding()
        .navigationTitle("Profile")
    }

    // MARK: - Subviews

    private var profileHeader: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color.accentColor.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay {
                    Text(user.name.prefix(1))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }

            VStack(spacing: 4) {
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var navigationActions: some View {
        VStack(spacing: 12) {
            Button("Go to Settings") {
                router.navigate(to: .settings)
            }
            .buttonStyle(.borderedProminent)

            Button("Go to Detail #42") {
                router.navigate(to: .detail(id: 42))
            }
            .buttonStyle(.bordered)
        }
    }

    private var popActions: some View {
        VStack(spacing: 10) {
            Button("Pop (Go Back)") {
                router.pop()
            }

            Button("Pop to Root") {
                router.popToRoot()
            }
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ProfileView(user: .alice)
    }
    .environment(Router<AppRoute>())
}

#Preview("Dark Mode") {
    NavigationStack {
        ProfileView(user: .bob)
    }
    .environment(Router<AppRoute>())
    .preferredColorScheme(.dark)
}
