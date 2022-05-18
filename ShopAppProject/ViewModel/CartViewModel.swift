//
//  CartViewModel.swift
//  ShopAppProject
//
//  Created by developer on 5/13/22.
//

import Foundation
import UIKit

struct CartViewModel {

    func calculateTotal(productCells: [ProductCellViewModel]) -> Double {
        var total = 0.0
        for item in productCells {
            total += Double(item.price) ?? 0
        }
        return total
    }
    
    var updateTableView: () -> Void = { print("closure")}
    
    func showAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: AlertKeys.delete.rawValue, style: .default) {
            action in
            self.updateTableView()
        }
        let cancel = UIAlertAction(title: AlertKeys.cancel.rawValue, style: .cancel) {
            action in
            print("Item was not deleted")
        }
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        return alert
    }
}
