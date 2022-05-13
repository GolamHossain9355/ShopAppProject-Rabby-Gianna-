//
//  CartViewController.swift
//  ShopAppProject
//
//  Created by developer on 5/12/22.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
   
    var cartItems: [ProductCellViewModel] = [ProductCellViewModel]() {
        didSet {

        }
    }
    
    var cartTotal: Double {
        var total = 0.0
        for item in cartItems {
            total += Double(item.price) ?? 0
        }
        return total
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("in cart")
        cartTableView.dataSource = self
        cartTableView.register(ProductTableViewCell.getNib(), forCellReuseIdentifier: ProductTableViewCell.identifier)
        cartTableView.register(CartTotalTableViewCell.getNib(), forCellReuseIdentifier: CartTotalTableViewCell.identifier)
        
        if cartItems.count > 0 {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
    }
    
    
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //basically when the index is at the end of cartitems, we add a new cell to there for total
        if indexPath.row == cartItems.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTotalTableViewCell.identifier, for: indexPath) as? CartTotalTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(price: self.cartTotal)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let cvm = cartItems[indexPath.row]
        cell.configure(cellVM: cvm)
        return cell
    }
    
}
