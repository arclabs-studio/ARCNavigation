//
//  DetailView.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import ARCNavigation
import SwiftUI

/// Detail screen demonstrating recursive navigation.
struct DetailView: View {

    // MARK: - Properties

    let id: Int
    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        VStack(spacing: 32) {
            headerSection
            navigationSection
            Spacer()
            popSection
        }
        .padding()
        .navigationTitle("Detail #\(id)")
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("#\(id)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(Color.accentColor)

            Text("Demonstrates navigation with Int associated value")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var navigationSection: some View {
        VStack(spacing: 12) {
            Button("Go to Detail #\(id + 1)") {
                router.navigate(to: .detail(id: id + 1))
            }
            .buttonStyle(.borderedProminent)

            Button("Go to Profile (Charlie)") {
                router.navigate(to: .profile(user: .charlie))
            }
            .buttonStyle(.bordered)
        }
    }

    private var popSection: some View {
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
        DetailView(id: 1)
    }
    .environment(Router<AppRoute>())
}

#Preview("Dark Mode") {
    NavigationStack {
        DetailView(id: 42)
    }
    .environment(Router<AppRoute>())
    .preferredColorScheme(.dark)
}
