//
//  ImageCacheService.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/6/25.
//

import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(for url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }
    
    func saveImage(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }
}
