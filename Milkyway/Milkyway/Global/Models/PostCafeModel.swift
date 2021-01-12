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
    var longitude, latitude: Double
    var honeyTip: [Int]
    var menu: [Menu]
}

