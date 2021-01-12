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
        guard let cafe = cafe.stringByAddingPercentEncodingForFormData() else { return }
        let URL = APIConstants.searchForReport + "?query=" + cafe
        //let token = KeychainWrapper.standard.string(forKey: "Token")
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjozMywiaWF0IjoxNjEwNDQyODc1LCJleHAiOjE2MTMwMzQ4NzUsImlzcyI6Im1pbGt5V2F5In0.xMCBH3wzwo0U80MbGD6vCu_aigtSLcCasRI3MG-7l3A"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token
        ]
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: URLEncoding.queryString,
                                     headers: headers)
        
        dataRequest.responseData{ (response) in
            
            print("url\(URL)")
            print("Response: \(response)")
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
                                dump(result)
                                completion(.success(result.data ?? cafe.self))
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
            case .failure(let err):
                print("에러\(err.localizedDescription)")
                completion(.networkFail)
                
            }
        }
        
        
        
    }
    
    // MARK: -  홈 화면 - 검색
    func homeSearchCafe(_ cafe: String,
                        completion: @escaping(NetworkResult<Any>) -> Void){
        
        guard let cafe = cafe.stringByAddingPercentEncodingForFormData() else { return }
        let URL = APIConstants.searchHome + cafe
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjozMywiaWF0IjoxNjEwNDQyODc1LCJleHAiOjE2MTMwMzQ4NzUsImlzcyI6Im1pbGt5V2F5In0.xMCBH3wzwo0U80MbGD6vCu_aigtSLcCasRI3MG-7l3A"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token
        ]
        
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     parameters: nil,
                                     encoding: URLEncoding.default,
                                     headers: headers)
        dataRequest.responseData{ (response) in
            
            print("url\(URL)")
            print("Response: \(response)")
            
            switch response.result {
            
            case .success(_):
                if let value = response.value {
                    if let status = response.response?.statusCode {
                        print("현상태:\(status)")
                        switch status {
                        
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseResult<CafeHomeResult>.self, from: value)
                                dump(result)
                                completion(.success(result.data ?? cafe.self))
                            } catch {
                                completion(.pathErr)
                                print("에러\(error.localizedDescription)")
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
            case .failure(let err):
                print("에러\(err.localizedDescription)")
                completion(.networkFail)
                
            }
            
            
            
        }
    }
    
    
}

