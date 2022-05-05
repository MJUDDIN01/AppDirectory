//
//  ImageDownloader.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import Foundation
import UIKit

protocol ImageDownLoaderType {
    func getImage(url:String, completion:@escaping (Data)->Void)
}

class ImageDownloader:ImageDownLoaderType {

    static let shared = ImageDownloader()
    private init() {}

    func getImage(url: String, completion:@escaping (Data) -> Void) {
        
        let imageCacher = ImageCacher.shared
        
        if let image = imageCacher.getImage(url: url) {
            completion(image)
        }else {
            dowloadImage(url: url) { imageData in
                imageCacher.saveImage(url: url, data:imageData )
                completion(imageData)
            }
        }
    }

    private func dowloadImage(url:String, completion:@escaping (Data)->Void) {

        guard let _url = URL(string: url) else {
            return
        }

        URLSession.shared.dataTask(with: _url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }

              completion(data)
        }.resume()

    }
}

