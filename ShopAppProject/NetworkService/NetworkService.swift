//
//  NetworkService.swift
//  ShopAppProject
//
//  Created by developer on 5/11/22.
//

import Foundation
import UIKit

var makupStr = "https://makeup-api.herokuapp.com/api/v1/products.json"

class NetwordService {
    private init() {}
    static let shared = NetwordService()
    
    let cache = NSCache<NSString, UIImage>()
    let defaultImage = UIImage(named: "imageNotFoundAsset")
    var defaultImageData: Data {
        self.defaultImage!.pngData()!
    }
    
    func getData(completion: @escaping ([Product]) -> Void) {
        guard let url = URL(string: makupStr) else {
            print("Invalid Url")
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard let data = data, error == nil else {
                print("Invalid Data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Indalid status code")
                return
            }
            
            do {
                let model = try JSONDecoder().decode([Product].self, from: data)
                completion(model)
            } catch {
                print("Error occured while getting data")
                print(error)
            }
        }.resume()
    }
    
    func getImage(imageUrl: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: imageUrl) else {
            print("Invalid Image Url")
            return
        }
        
        if let image = cache.object(forKey: imageUrl as NSString), let imageData = image.pngData() {
            print("Caching image from memory")
            completion(imageData)
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
                
                guard let data = data, error == nil else {
                    print("Invalid image data")
                    
                    completion(self.defaultImageData)
                    self.cache.setObject(self.defaultImage!, forKey: imageUrl as NSString)
                    
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("Invalid status code")
                    
                    completion(self.defaultImageData)
                    self.cache.setObject(self.defaultImage!, forKey: imageUrl as NSString)
                    
                    return
                }
                
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: imageUrl as NSString)
                }
                
                completion(data)
            }.resume()
        }
    
}
