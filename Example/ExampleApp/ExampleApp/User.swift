//
//  User.swift
//  ExampleApp
//
//  Created by ARC Labs Studio on 2025-12-28.
//

import Foundation

/// Sample user entity for demonstration purposes.
struct User: Identifiable, Hashable {

    // MARK: - Properties

    let id: UUID
    let name: String
    let email: String

    // MARK: - Initialization

    init(id: UUID = UUID(), name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// MARK: - Sample Data

extension User {

    static let alice = User(name: "Alice Johnson", email: "alice@example.com")
    static let bob = User(name: "Bob Smith", email: "bob@example.com")
    static let charlie = User(name: "Charlie Brown", email: "charlie@example.com")

    static let samples: [User] = [.alice, .bob, .charlie]
}
