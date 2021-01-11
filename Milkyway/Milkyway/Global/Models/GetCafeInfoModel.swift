//
//  GetCafeInfoModel.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/12.
//

import Foundation

struct CafeResult: Codable {
    
    let cafeName, cafeAddress, cafeMapX, cafeMapY: String
    let isReported: Bool
}
