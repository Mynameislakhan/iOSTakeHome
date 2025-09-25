//
//  UsersResponse.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 17/09/25.
//

import Foundation

// MARK: - UsersResponse
struct UsersResponse: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
}
