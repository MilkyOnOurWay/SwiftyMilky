//
//  GetMilkyHomeModel.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/11.
//

import Foundation

// MARK: - HomeData
struct HomeData: Codable {
    let aroundCafe: [AroundCafe]
    let nickName: String
}

// MARK: - AroundCafe
struct AroundCafe: Codable {
    let id: Int
    let cafeName, cafeAddress, businessHours: String
    let cafeMapX, cafeMapY: Double
    let isReal: Bool
}
