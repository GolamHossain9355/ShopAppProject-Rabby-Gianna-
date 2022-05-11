//
//  ProductTableViewCell.swift
//  ShopAppProject
//
//  Created by developer on 5/11/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ProductTableViewCell.self)
    static func getNib() -> UINib {
        UINib(nibName: ProductTableViewCell.identifier, bundle: nil)
    }

    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImageView.image = nil
    }
    
    
    weak var productCellViewModel: ProductCellViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.brandNameLabel.text = self.productCellViewModel?.brandName
                self.itemNameLabel.text = self.productCellViewModel?.itemName
                self.priceLabel.text = self.productCellViewModel?.price
            }
        }
    }
    
    deinit {
        print("Cell Deinitialized")
    }
    
    func configure(cellVM: ProductCellViewModel) {
        self.productCellViewModel = cellVM
        bindImage()
        cellVM.fetchImage()
    }
    
    func bindImage() {
        self.productCellViewModel?.updateImage = {
            guard let imageData = self.productCellViewModel?.imageData else {
                return
            }
            
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: imageData) ?? UIImage(named: "imageNotFoundAsset")
            }
        }
    }
    
}
