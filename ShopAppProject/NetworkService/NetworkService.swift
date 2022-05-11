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
    
    func getData(completion: @escaping ([Makeup]) -> Void) {
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
                let model = try JSONDecoder().decode([Makeup].self, from: data)
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
            completion(imageData)
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
                
                guard let data = data, error == nil else {
                    print("Invalid image data")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("Invalid status code")
                    return
                }
                
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: imageUrl as NSString)
                }
                
                completion(data)
            }.resume()
        }
    
}
