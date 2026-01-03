//
//  HomeView.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import ARCNavigation
import SwiftUI

/// Main navigation hub demonstrating ARCNavigation features.
struct HomeView: View {

    // MARK: - Properties

    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        List {
            usersSection
            quickActionsSection
            stackInfoSection
        }
        .navigationTitle("ARCNavigation Demo")
    }

    // MARK: - Sections

    private var usersSection: some View {
        Section("Users (Associated Values)") {
            ForEach(User.samples) { user in
                Button {
                    router.navigate(to: .profile(user: user))
                } label: {
                    UserRow(user: user)
                }
                .foregroundStyle(.primary)
            }
        }
    }

    private var quickActionsSection: some View {
        Section("Quick Actions") {
            Button("Open Settings") {
                router.navigate(to: .settings)
            }

            Button("Open Detail #1") {
                router.navigate(to: .detail(id: 1))
            }
        }
    }

    private var stackInfoSection: some View {
        Section("Navigation Stack") {
            LabeledContent("Stack Size", value: "\(router.count)")
            LabeledContent("Is Empty", value: router.isEmpty ? "Yes" : "No")
        }
    }
}

// MARK: - UserRow

private struct UserRow: View {

    let user: User

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.accentColor.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay {
                    Text(user.name.prefix(1))
                        .font(.headline)
                        .foregroundStyle(Color.accentColor)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.body)
                Text(user.email)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
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
