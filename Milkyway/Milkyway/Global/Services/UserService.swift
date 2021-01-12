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
}
