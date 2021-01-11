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
    
    enum CodingKeys: String, CodingKey {
        case aroundCafe = "aroundUniverse"
        case nickName = "nickName"
    }
}

// MARK: - AroundCafe
struct AroundCafe: Codable {
    let id: Int
    let cafeName, cafeAddress, businessHours: String
    let longitude, latitude: Double
    let isReal: Bool
    
}
