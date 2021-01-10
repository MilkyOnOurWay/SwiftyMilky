//
//  PostCafeModel.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/10.
//

import Foundation

// MARK: - Cafepost
struct Cafepost: Codable {
    var cafeName, cafeAddress: String?
    let cafeMapX, cafeMapY: Double
    var honeyTip: [Int]
    var menu: [Menu]
}

