//
//  PostModifyModel.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/12.
//

import Foundation

// MARK: - EditPost
struct EditPost: Codable {
    var cafeId: Int
    var reason: String
}

struct DeletePost: Codable {
    var cafeId: Int
    var reason: Int
}
