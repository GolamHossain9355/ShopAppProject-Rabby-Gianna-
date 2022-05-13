//
//  SavedProductsViewController.swift
//  ShopAppProject
//
//  Created by developer on 5/13/22.
//

import UIKit

class SavedProductsViewController: UIViewController {

    
    @IBOutlet weak var savedCellsTableView: UITableView!
    
    var savedCells = [ProductCellViewModel]()
    var savedCellsDelegate: BuyHandler?
    
    @IBAction func clearCellsButton(_ sender: UIBarButtonItem) {
        self.savedCells.removeAll()
        self.savedCellsDelegate?.removeSavedCells()
        self.savedCellsTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCellsTableView.dataSource = self
        savedCellsTableView.register(ProductTableViewCell.getNib(), forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        if !savedCells.isEmpty {
            DispatchQueue.main.async {
                self.savedCellsTableView.reloadData()
            }
        }
    }

}

extension SavedProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let cVM = savedCells[indexPath.row]
        cell.configure(cellVM: cVM)
        
        return cell
    }
    
}
