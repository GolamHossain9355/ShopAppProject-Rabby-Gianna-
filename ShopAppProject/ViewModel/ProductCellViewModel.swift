//
//  ProductCellViewModel.swift
//  ShopAppProject
//
//  Created by developer on 5/11/22.
//

import Foundation
import UIKit

class ProductCellViewModel {
    var productData: Product
    
    init(productData: Product) {
        self.productData = productData
    }
    
    var defaultImage = UIImage(named: "imageNotFoundAsset")?.pngData()
    
    var brandName: String {
        productData.brandName ?? "Brand name not present"
    }
    var itemName: String {
        productData.itemName
    }
    var price: String {
        productData.price ?? "Price not present"
    }
    
    var updateImage: () -> Void = { print("Clouser") }
    var imageData: Data? {
        didSet {
            DispatchQueue.main.async {
                self.updateImage()
            }
        }
    }
    
    func fetchImage() {
        NetwordService.shared.getImage(imageUrl: productData.imageUrl) {
            data in
            self.imageData = data 
        }
    }
    
}
