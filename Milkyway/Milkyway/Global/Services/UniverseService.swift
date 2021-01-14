//
//  UniverseService.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/12.
//

import Foundation
import Alamofire

struct UniverseService {
    
    private init() {}
    
    static let shared = UniverseService()
    
    func GetUniverse(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.showUniverse
        print(URL)
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token
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
                                let result = try decoder.decode(ResponseSimpleResult<UniverseData>.self,
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
    
    // MARK: - 유니버스 추가
    func addUniverse(_ cafeId: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        
        print("Server Universe add \(cafeId)")
        
        let URL = APIConstants.addUniverse
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token
        ]
        
        let body: Parameters = [
            "cafeId": cafeId
        ]
        
        let dataRequest = AF.request(URL,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData {(response) in
            
            switch response.result {
            
            case .success(_):
                if let value = response.value {
                    if let status = response.response?.statusCode {
                        print(status)
                        switch status {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseSimpleResult<AddUniverse>.self,from: value)
                                print("단순결과\(result)")
                                completion(.success(result.data ?? Token.self))
                            } catch {
                                print(error.localizedDescription)
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
            case .failure(let err):
                print("유니버스 추가 에러 \(err.localizedDescription)")
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - 유니버스 삭제
    
    func deleteUniverse(_ cafeId: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        
        print("Server Universe delete \(cafeId)")
        
        let URL = APIConstants.deleteUniverse + "\(cafeId)"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token
        ]
        
        
        print(cafeId)
        print(URL)
        let dataRequest = AF.request(URL,
                                     method: .delete,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        dataRequest.responseData {(response) in
            
            switch response.result {
            
            case .success(_):
                if let value = response.value {
                    if let status = response.response?.statusCode {
                        print(status)
                        switch status {
                        case 200:
                            do {
                              let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseSimpleResult<ThrowUniverse>.self,from: value)
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
            case .failure(let err):
                print("유니버스 삭제 에러 \(err.localizedDescription)")
                completion(.networkFail)
            }
        }
    }
    
    
}

