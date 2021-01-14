//
//  DetailCafeService.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/10.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct DetailCafeService {
    
    private init() {}
    
    static let shared = DetailCafeService()
    
    func DetailInfoGet(cafeId: Int,
                       completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.loadCafeInfo + "\(cafeId)"
        print(URL)
        
        let token = KeychainWrapper.standard.string(forKey: "Token")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token ?? ""
        ]
        
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: headers
                                     )
        
        dataRequest.responseData{ (response) in
            
            switch response.result {
            
            case .success(_):
                if let value = response.value {
                    if let status = response.response?.statusCode {
                        print("helpme")
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseSimpleResult<CafeDatas>.self,
                                                                from: value)
                                completion(.success(result.data ?? Token.self))

                            } catch {
                                completion(.pathErr)
                            }
                        case 400:
                            completion(.pathErr)
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }
                    }
                }
                break
            case .failure(_):
                completion(.networkFail)
            }
            
        }
    }
}
