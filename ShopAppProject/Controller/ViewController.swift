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
    
    var cellsChosen = [ProductCellViewModel]()
    
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

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    
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
        
        if cellsChosen.count > 0 {
            print(cellsChosen[cellsChosen.count - 1].price)
        }
        
        let cvm = productViewModel.getCellVM(indexPath)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addToCart = UIAlertAction(title: "Add To Cart", style: .default) {
            action in
            self.cellsChosen.append(cvm)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            action in
            print(action)
        }
        
        alert.addAction(addToCart)
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

