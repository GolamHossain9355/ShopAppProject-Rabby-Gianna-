//
//  CartViewController.swift
//  ShopAppProject
//
//  Created by developer on 5/12/22.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
   
    @IBAction func buyProducts(_ sender: UIButton) {
        self.buyHandlerDelegate?.addCells(cells: cartItems)
        self.cartItems = [ProductCellViewModel]()
        self.cartTableView.reloadData()
        self.buyHandlerDelegate?.clearCells()
        self.makeLabel()
    }
    var cartItems: [ProductCellViewModel] = [ProductCellViewModel]()
    var buyHandlerDelegate: BuyHandler?
    var cartViewModel = CartViewModel()
    
    func setUpTotalLabel() {
        
    }
    
    func makeLabel() {
        self.cartTableView.isHidden = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        label.textAlignment = .center
        label.text = "Purchase successful!"
        self.view.addSubview(label)
        self.setUpTotalLabel()
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
        //basically when the index is at the end of cartitems, we add a new cell to there for total
        if indexPath.row == cartItems.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTotalTableViewCell.identifier, for: indexPath) as? CartTotalTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(price: cartViewModel.calculateTotal(productCells: cartItems))
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
        
        
        self.cartViewModel.updateTableView = {
            self.cartItems.remove(at: indexPath.row)
            self.cartTableView.deleteRows(at: [indexPath], with: .fade)
            self.buyHandlerDelegate?.removeCell(indexPath)
            self.cartTableView.reloadData()
        }
        
        let alert = self.cartViewModel.showAlert()
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if indexPath.row < cartItems.count {
                return true
            }
            return false
        }
}

