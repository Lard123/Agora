//
//  FirebaseUIImageCacheExtension.swift
//  Agora
//
//  Created by Varun Shenoy on 12/1/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

// create a cache
let imageCache =  NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    // load the image from an online url, generally from Firebase Storage
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        let url = NSURL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        // get the image
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, respones, error) in
            
            if error != nil {
                return
            }
            
            // switch back to main thread for design purposes                                                            
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            })
            
        }).resume()
    }
    
}
