//
//  SearchCafeService.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/12.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct SearchCafeService {
    
    private init() {}
    static let shared = SearchCafeService()
    
    // MARK: - 제보하기-검색
    func searchReportCafe(_ cafe: String,
                          completion: @escaping(NetworkResult<Any>) -> Void) {
        //guard let cafe = cafe.stringByAddingPercentEncodingForFormData() else { return }
        let URL = APIConstants.searchForReport
        //let token = KeychainWrapper.standard.string(forKey: "Token")
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token ?? ""
        ]
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData{ (response) in
            
            switch response.result {
            
            case .success(_):
                if let value = response.value {
                    if let status = response.response?.statusCode {
                        print("현상태:\(status)")
                        switch status {
                        
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseResult<CafeResult>.self, from: value)
                                completion(.success(result.data ?? CafeResult.self))
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
