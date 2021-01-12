//
//  GetMilkyHomeModel.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/11.
//

import Foundation

// MARK: - HomeData
struct HomeData: Codable {
    let result: [AroundCafe]
    let nickName: String
}

// MARK: - AroundCafe
struct AroundCafe: Codable {
    let id, universeCount: Int
    let cafeName, cafeAddress, businessHours: String
    let longitude, latitude: Double
    let isUniversed: Bool
    
}
