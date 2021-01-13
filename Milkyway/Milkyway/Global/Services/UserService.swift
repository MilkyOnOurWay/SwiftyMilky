//
//  UserService.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/09.
//

import Foundation
import Alamofire

struct UserService {
    
    private init() {}
    
    static let shared = UserService()
    
    func SignUp(_ uuid: String, _ nickName: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.signUp
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let body: Parameters = [
            "uuid": uuid,
            "nickName": nickName
        ]
        
        let dataRequest = AF.request(URL,
                                     method: .post,
                                     parameters: body,
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
                                let result = try decoder.decode(ResponseSimpleResult<Token>.self,from: value)
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
    
    // MARK: - 닉네임 변경 API 연결
    
    func changeNickname(_ nickName: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.changeNick
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        ]
        
        let body: Parameters = [
            
            "newNickName": nickName
        ]
        
        let dataRequest = AF.request(URL,
                                     method: .put,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData { (response) in
            
            switch response.result {
            
            case .success(_):
                if let value = response.value {
                    
                    if let status = response.response?.statusCode {
                        
                        print(status)
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseTempResult.self,from: value)
                                
                            } catch {
                                completion(.pathErr)
                            }
                        case 400:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseTempResult.self,
                                                                from: value)
                                
                                completion(.requestErr(result.message))
                            } catch {
                                completion(.pathErr)
                            }
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }
                    }
                }
            case .failure(_):
                completion(.networkFail)
            }
        }
    }
    
    
}
