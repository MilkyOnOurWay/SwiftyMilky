//
//  GetCafeInfoModel.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/12.
//

import Foundation

// MARK: - 제보하기 검색에서 사용
struct CafeResult: Codable {
    
    let cafeName, cafeAddress, longitude, latitude: String
    let isReported: Bool
}

// MARK: - 홈 화면 검색에서 사용
struct CafeHomeResult: Codable {
    
    let cafeName, cafeAddress: String
    let longitude,latitude: Double
}
