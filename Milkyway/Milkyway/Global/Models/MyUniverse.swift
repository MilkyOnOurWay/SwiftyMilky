//
//  MyUniverse.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/12.
//

import Foundation

// MARK: - 유니버스 추가 모델
struct AddUniverse: Codable {
    
    let universeOn: UniverseOn
    let universeCount: Int
    
}

struct UniverseOn: Codable {
    
    let universeID, userID, cafeID: Int
    enum CodingKeys: String, CodingKey {
        case universeID = "universeId"
        case userID = "userId"
        case cafeID = "cafeId"
    }
 
  
}

// MARK: - 유니버스 삭제 모델
struct DeleteUniverse: Codable {
    
    let universeOff: [UniverseOff]
    let universeCount: Int
}
struct UniverseOff: Codable {
    let universeID, userID, cafeID: Int

    enum CodingKeys: String, CodingKey {
        case universeID = "universeId"
        case userID = "userId"
        case cafeID = "cafeId"
    }
}

