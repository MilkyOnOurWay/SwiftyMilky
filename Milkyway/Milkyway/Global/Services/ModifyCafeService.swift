//
//  ModifyCafeService.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/12.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct ModifyCafeService {
    
    private init() {}
    
    static let shared = ModifyCafeService()
    
    // MARK: - EditCafe
    
    func EditCafe(cafeId: Int,
                  editPost: EditPost,
                  completion: @escaping (NetworkResult<Any>) -> Void) {
        
        // POST 카페 정보 수정 요청 report/:cafeId/editCafe
        let URL = APIConstants.fixCafeInfo + "\(cafeId)/editCafe"
        print(URL)
        //let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        let token = KeychainWrapper.standard.string(forKey: "Token")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token ?? ""
        ]
        
        let params = ["reason": editPost.reason]
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
    
    //MARK: - DeleteCafe
    func DeleteCafe(cafeId: Int,
                    deletePost: DeletePost,
                    completion: @escaping (NetworkResult<Any>) -> Void) {
        
        // POST 카페 정보 수정 요청 report/:cafeId/editCafe
        let URL = APIConstants.fixCafeInfo + "\(cafeId)/deleteCafe"
        print(URL)
        //let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        let token = KeychainWrapper.standard.string(forKey: "Token")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token ?? ""
        ]
        
        let params = ["reason": deletePost.reason]
        
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
