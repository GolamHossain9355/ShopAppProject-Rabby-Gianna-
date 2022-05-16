//
//  ProductViewModel.swift
//  ShopAppProject
//
//  Created by developer on 5/11/22.
//

import Foundation
import UIKit

class ProductViewModel {

    var prodctCellModels = [ProductCellViewModel]()
    var numCells: Int {
        prodctCellModels.count
    }
    
    func fetchdata(completion: @escaping () -> Void) {
        NetwordService.shared.getData(completion: {
            products in
            for product in products {
                self.prodctCellModels.append(ProductCellViewModel(productData: product))
            }
            
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    func getCellVM(_ indexPath: IndexPath) -> ProductCellViewModel {
        prodctCellModels[indexPath.row]
    }
    
    var updateCart: () -> Void = { print("Clouser") }
    
    func showAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addToCart = UIAlertAction(title: "Add To Cart", style: .default) {
            action in
            self.updateCart()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            action in
            print("Item was not added to Cart")
        }
        
        alert.addAction(addToCart)
        alert.addAction(cancel)
        
        return alert
    }
    
}
