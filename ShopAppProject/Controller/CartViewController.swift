//
//  CartViewController.swift
//  ShopAppProject
//
//  Created by developer on 5/12/22.
//

import UIKit
//buy button delegates "Saved Items" back to product view controller

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
   
    @IBAction func buyProducts(_ sender: UIButton) {
        self.buyHandlerDelegate?.addCells(cells: cartItems)
        self.cartItems = [ProductCellViewModel]()
        self.cartTableView.reloadData()
        self.buyHandlerDelegate?.clearCells()
    }
    var cartItems: [ProductCellViewModel] = [ProductCellViewModel]()
    var buyHandlerDelegate: BuyHandler?
    
    
    var cartTotal: Double {
        var total = 0.0
        for item in cartItems {
            total += Double(item.price) ?? 0
        }
        return total
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
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

extension CartViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)  {
        if editingStyle == .delete {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .default) {
                action in
                self.cartItems.remove(at: indexPath.row)
                self.cartTableView.deleteRows(at: [indexPath], with: .fade)
                self.cartTableView.reloadData()
                self.buyHandlerDelegate?.removeCell(indexPath)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
                action in
                print("Item was not deleted")
            }
            
            alert.addAction(delete)
            alert.addAction(cancel)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
