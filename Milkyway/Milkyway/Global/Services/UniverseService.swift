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
                                let result = try decoder.decode(ResponseSimpleResult<HomeData>.self,
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
                                let result = try decoder.decode(ResponseResult<AddUniverse>.self,from: value)
                                completion(.success(result.data ?? AddUniverse.self))
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
                print("유니버스 추가 에러 \(err.localizedDescription)")
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - 유니버스 삭제
    
    func deleteUniverse(_ cafeId: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.deleteUniverse
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1LCJpYXQiOjE2MDk3Nzg0NjksImV4cCI6MTYxMjM3MDQ2OSwiaXNzIjoibWlsa3lXYXkifQ.c2JAdyd0pGQzbmT0E_yl51eAGkcO71YfokwJebqqDME"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token
        ]
        
        // 서버 위키에 request body 없다고 나오는데 잘못 올린듯
        let body: Parameters = [
            "cafeId": cafeId
        ]
        
        let dataRequest = AF.request(URL,
                                     method: .delete,
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
                            do {
                              let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseResult<DeleteUniverse>.self,from: value)
                                completion(.success(result.data ?? [DeleteUniverse].self))
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

