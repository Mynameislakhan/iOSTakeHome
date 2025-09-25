//
//  Models.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 17/09/25.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
