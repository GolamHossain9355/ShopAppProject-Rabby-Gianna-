//
//  ViewController.swift
//  ShopAppProject
//
//  Created by developer on 5/11/22.
//

import UIKit

protocol BuyHandler {
    func removeCell(_ indexPath: IndexPath)
    func addCells(cells: [ProductCellViewModel])
    func clearCells()
    func removeSavedCells()
}

class ViewController: UIViewController, BuyHandler {
    
    @IBOutlet weak var productTableView: UITableView!
    
    var productViewModel = ProductViewModel()
    var cellsAddedToCart = [ProductCellViewModel]()
    var savedCells = [ProductCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.register(ProductTableViewCell.getNib(), forCellReuseIdentifier: ProductTableViewCell.identifier)
        productViewModel.fetchdata {
            DispatchQueue.main.async {
                self.productTableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cartVC = segue.destination as? CartViewController
        cartVC?.cartItems = self.cellsAddedToCart
        cartVC?.buyHandlerDelegate = self
        
        let savedCellVC = segue.destination as? SavedProductsViewController
        savedCellVC?.savedCells = self.savedCells
        savedCellVC?.savedCellsDelegate = self
    }
    
    func clearCells() {
        self.cellsAddedToCart = [ProductCellViewModel]()
    }
    
    func removeCell(_ indexPath: IndexPath) {
        self.cellsAddedToCart.remove(at: indexPath.row)
    }
    
    func addCells(cells: [ProductCellViewModel]) {
        self.savedCells.append(contentsOf: cells)
    }
    
    func removeSavedCells() {
        self.savedCells.removeAll()
    }
    
    deinit {
        print("ViewController Deinitialized")
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productViewModel.numCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let cvm = productViewModel.getCellVM(indexPath)
        cell.configure(cellVM: cvm)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let cvm = productViewModel.getCellVM(indexPath)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addToCart = UIAlertAction(title: "Add To Cart", style: .default) {
            action in
            self.cellsAddedToCart.append(cvm)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            action in
            print("Item was not added to Cart")
        }
        
        alert.addAction(addToCart)
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

