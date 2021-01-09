//
//  GetDetailCafeModel.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/10.
//

import Foundation

// MARK: - CafeDatas
struct CafeDatas: Codable {
    let cafeInfo: CafeInfo
    let menu: [Menu]
    var universeCount: Int

}

// MARK: - CafeInfo
struct CafeInfo: Codable {
    let id: Int
    let cafeName, cafeAddress, businessHours, cafePhoneNum: String
    let cafeLink: String
    let honeyTip: [Int]
    
}

// MARK: - Menu
struct Menu: Codable {
    var menuName, price: String
    let category: [Int]

    enum CodingKeys: String, CodingKey {
        case menuName, price, category
    }
    
   
}
