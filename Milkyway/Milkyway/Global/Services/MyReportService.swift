//
//  MyReportService.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/13.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct MyReportService {

    private init() {}

    static let shared = MyReportService()

    // MARK: - 나의 제보 불러오기
    func GetMyReport(completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.showMyReport
        print(URL)
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoyLCJpYXQiOjE2MTQwNTEwODUsImV4cCI6MTYxNjY0MzA4NSwiaXNzIjoibWlsa3lXYXkifQ.Z7BEPNwsI8RovCa2QFN5jy7M_POdENPqSkoMePL-Jqs"
//        let token = KeychainWrapper.standard.string(forKey: "Token")
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
                        print("myreport - get server")
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseSimpleResult<MyReportData>.self,
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
    // MARK: - 취소된 카페 삭제
    
    func deleteCancelCafe(_ cafeId: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        
        let URL = APIConstants.deleteReport + "\(cafeId)"
        let token = KeychainWrapper.standard.string(forKey: "Token")
        //let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoxODcsImlhdCI6MTYxMDcyNjg0MCwiZXhwIjoxNjEzMzE4ODQwLCJpc3MiOiJtaWxreVdheSJ9.vpLw3nCURheodiv6hPu14kXwVueHXOZ5Fwyv_BqRTPY"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token ?? ""
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
                                let result = try decoder.decode(ResponseTempResult.self,from: value)
                                completion(.success(Token.self))
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
                print("취소된 제보 삭제 에러 \(err.localizedDescription)")
                completion(.networkFail)
            }
        }
    }
}
