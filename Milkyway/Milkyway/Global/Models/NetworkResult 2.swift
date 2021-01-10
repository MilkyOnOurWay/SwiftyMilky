//
//  NetworkResult.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/09.
//

import Foundation

enum NetworkResult<T> {
    
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
    
}
