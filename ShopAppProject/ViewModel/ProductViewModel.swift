//
//  ProductViewModel.swift
//  ShopAppProject
//
//  Created by developer on 5/11/22.
//

import Foundation

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
    
}
