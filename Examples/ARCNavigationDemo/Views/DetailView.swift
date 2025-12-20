//
//  DetailView.swift
//  ARCNavigationDemo
//
//  Created by ARC Labs Studio on 2025-11-13.
//

import SwiftUI
import ARCNavigation

struct DetailView: View {

    // MARK: - Properties

    let id: Int
    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        VStack(spacing: 30) {
            Text("Detail #\(id)")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("This demonstrates navigation with associated values")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            VStack(spacing: 15) {
                Button("Go to Another Detail") {
                    router.navigate(to: .detail(id: id + 1))
                }
                .buttonStyle(.borderedProminent)

                Button("Go to Profile") {
                    router.navigate(to: .profile(userName: "Charlie"))
                }
                .buttonStyle(.bordered)
            }

            Divider()

            VStack(spacing: 10) {
                Button("Pop") {
                    router.pop()
                }

                Button("Pop to Root") {
                    router.popToRoot()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Detail #\(id)")
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
        DetailView(id: 1)
    }
    .environment(Router<AppRoute>())
    .preferredColorScheme(.dark)
}
