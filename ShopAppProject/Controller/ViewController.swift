//
//  ViewController.swift
//  ShopAppProject
//
//  Created by developer on 5/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var productTableView: UITableView!
    
    var productViewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.dataSource = self
        productTableView.register(ProductTableViewCell.getNib(), forCellReuseIdentifier: ProductTableViewCell.identifier)
        productViewModel.fetchdata {
            DispatchQueue.main.async {
                self.productTableView.reloadData()
            }
        }
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

