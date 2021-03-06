//
//  HomeService.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/11.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct HomeService {
    
    private init() {}
    
    static let shared = HomeService()
    
    func GetMilkyHome(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.homeResult
        print(URL)
        let token = KeychainWrapper.standard.string(forKey: "Token") //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoyLCJpYXQiOjE2MTQwNTEwODUsImV4cCI6MTYxNjY0MzA4NSwiaXNzIjoibWlsa3lXYXkifQ.Z7BEPNwsI8RovCa2QFN5jy7M_POdENPqSkoMePL-Jqs"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token ?? ""
        ]
        
        print("headers: \(headers)")
        
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
                        print("home server")
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseSimpleResult<HomeData>.self,
                                                                from: value)
                                dump(result)
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
    
    func GetCategoryCafe(categoryId: Int,
                         completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.categoryHome + "\(categoryId)"
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
                        print("home server")
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseSimpleResult<CategoryData>.self,
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

