//
//  ExploreView.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2026-02-06.
//

import ARCNavigation
import SwiftUI

/// Explore tab root view demonstrating navigation within a specific tab.
struct ExploreView: View {
    // MARK: - Properties

    @Environment(Router<AppRoute>.self) private var router

    // MARK: - Body

    var body: some View {
        List {
            itemsSection
        }
        .navigationTitle("Explore")
    }

    // MARK: - Sections

    private var itemsSection: some View {
        Section("Items") {
            ForEach(1 ... 10, id: \.self) { id in
                Button {
                    router.navigate(to: .detail(id: id))
                } label: {
                    Label("Item #\(id)", systemImage: "number.circle")
                }
                .foregroundStyle(.primary)
            }
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ExploreView()
    }
    .environment(Router<AppRoute>())
}

#Preview("Dark Mode") {
    NavigationStack {
        ExploreView()
    }
    .environment(Router<AppRoute>())
    .preferredColorScheme(.dark)
}
