//
//  ApiError.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import Foundation


enum ApiError: Error , Equatable {
    case UrlNotCorrect(String)
    case recieveNilResponse(String)
    case recieveErrorHttpStatus(String)
    case recieveNilBody(String)
    case failedParse(String)
    case customError(Int)
}
