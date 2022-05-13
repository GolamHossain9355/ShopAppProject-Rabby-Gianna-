//
//  CartViewModel.swift
//  ShopAppProject
//
//  Created by developer on 5/13/22.
//

import Foundation


struct CartViewModel {

    func calculateTotal(productCells: [ProductCellViewModel]) -> Double {
        var total = 0.0
        for item in productCells {
            total += Double(item.price) ?? 0
        }
        return total
    }
}
