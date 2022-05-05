//
//  DirectoryApi.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import Foundation


protocol DirectoryApiType {
    func get<T:Decodable>(with request: DirectoryRequest, type:T.Type, completionHandler:@escaping(Result<[T],   ApiError>)->Void)
}

protocol Request {
    var url: String { get }
    var path: String { get }
}

struct DirectoryRequest: Request {
    
    private let baseUrl = "https://61e947967bc0550017bc61bf.mockapi.io/api/v1/"

    var path: String

    var url: String {
        return baseUrl + path
    }
}

struct DirectoryApi: DirectoryApiType {
  
    let apiTask: ApiProtocol
    
    
    func get<T>(with request: DirectoryRequest, type: T.Type, completionHandler: @escaping (Result<[T], ApiError>) -> Void) where T : Decodable {
        
        guard let url = URL(string: request.url) else {
            completionHandler(.failure(ApiError.UrlNotCorrect(Constants.urlFormatIssue)))
            return
        }
        apiTask.request(url) { data, statusCode, error in
           
            if let _ = error {
                completionHandler(.failure(ApiError.recieveErrorHttpStatus(Constants.responceNotFound)))
                return
            }
            if let responseError = ApiTask.check(statusCode: statusCode) {
                completionHandler(.failure(responseError))
                return
            }
            guard let data = data else {
                completionHandler(.failure(ApiError.recieveNilBody(Constants.dataNotFound)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode([T].self, from: data)
                completionHandler(.success(response))
            } catch {
                completionHandler(.failure(ApiError.failedParse(Constants.parsingFailed)))
            }
        }
    }
    
}
