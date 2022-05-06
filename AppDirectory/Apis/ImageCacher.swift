//
//  ImageCacher.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import Foundation
import UIKit

protocol ImageCacherType {
    func getImage(url:String)-> Data?
    func saveImage(url:String, data:Data)
}

class ImageCacher:ImageCacherType {
    static let shared = ImageCacher()
    var cache = NSCache<NSString, NSData>()

    private init(){
       // cache.countLimit = 100
    }
    
    func getImage(url: String) -> Data? {
        return cache.object(forKey: url as NSString) as Data?
    }
    
    func saveImage(url: String, data: Data) {
        cache.setObject(data as NSData, forKey: url as NSString)
    }
}

