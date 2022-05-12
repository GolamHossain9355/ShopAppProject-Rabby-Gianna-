//
//  CartTotalTableViewCell.swift
//  ShopAppProject
//
//  Created by developer on 5/12/22.
//

import UIKit

class CartTotalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    static let identifier = "CartTotalTableViewCell"
    static func getNib() -> UINib {
        UINib(nibName: CartTotalTableViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(price: Double){
        self.totalPriceLabel.text = "$\(price)"
    }
    
    
}
