//
//  ResponseResult.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/09.
//

import Foundation

struct ResponseResult<T: Codable>: Codable {
    var status: Int?
    var message: String?
    var data: [T]?
}

struct ResponseSimpleResult<T: Codable>: Codable {
    var status: Int?
    var message: String?
    var data: T?
}

struct ResponseTempResult: Codable {
    var status: Int?
    var message: String?
}
