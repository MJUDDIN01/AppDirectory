//
//  ApiTask.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import Foundation


public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol ApiProtocol {
    func request(_ url:URL, completion: @escaping (Data?, Int, Error?) -> Void)
}

open class ApiTask: ApiProtocol {
    
    func request(_ url: URL, completion: @escaping (Data?, Int, Error?) -> Void) {
         let task = ApiTask.apiTaskSession.dataTask(with: url, completionHandler: {(data, response, error) in
            
            completion(data, (response as! HTTPURLResponse).statusCode, error)
        })
        task.resume()
    }
    
    static let apiTaskSession: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)

    static internal func check(statusCode: Int) -> ApiError? {
        
        guard (200..<300) ~= statusCode else {
            return ApiError.customError(statusCode)
        }
        return nil
    }
}
