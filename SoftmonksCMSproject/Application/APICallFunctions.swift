//
//  APICallFunctions.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 28/05/24.
//

import Foundation
import Alamofire
    
//var responseVarialble: passResponse?

func passAPICall(_ parameters: [String: Any], completion: @escaping (Bool, String?, Int?) -> Void) {
    print(parameters)
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: PassResponse.self) { response in
                switch response.result {
                case .success(let rData):
                    print(rData)
                    guard rData.err == 0 else {
                        completion(false, rData.errMsg, rData.id)
                                            return
                                        }
                    completion(true, rData.successMsg, rData.id)
                case .failure(let error):
                    print(error)
                    completion(false, error.localizedDescription, 0)
                    
                }
            }
    }
