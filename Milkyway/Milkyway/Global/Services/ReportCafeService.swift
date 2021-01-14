//
//  ReportCafeService.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/11.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct ReportCafeService {
    
    private init() {}
    
    static let shared = ReportCafeService()
    
    func ReportCafe(cafepost: Cafepost,
                    completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.reportCafe
        
        let token = KeychainWrapper.standard.string(forKey: "Token")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token ?? ""
        ]
        
        var list: [[String: Any]] = []
        for me in cafepost.menu {
            var a: [String:Any] = [:]
            a["menuName"] = me.menuName
            a["price"] = me.price
            a["category"] = me.category
            list.append(a)
        }
        
        
        let params = ["cafeName": cafepost.cafeName! as String,
                      "cafeAddress": cafepost.cafeAddress! as String,
                      "longitude": cafepost.longitude,
                      "latitude": cafepost.latitude,
                      "honeyTip": cafepost.honeyTip,
                      "menu": list
        ] as [String : Any]
        
        dump(params)
        
        let dataRequest = AF.request(URL,
                                     method: .post,
                                     parameters: params,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData{ (response) in
            
            switch response.result {
            
            case .success(_):
                if let value = response.value {
                    if let status = response.response?.statusCode {
                        print(status)
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseTempResult.self,
                                                                from: value)
                                completion(.success(result))
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
