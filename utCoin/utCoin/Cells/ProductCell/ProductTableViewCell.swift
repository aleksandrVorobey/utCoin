//
//  ProductTableViewCell.swift
//  utCoin
//
//  Created by admin on 13.09.2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cashbackLabel: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    
    static let identifier = "ProductTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ProductTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageProduct.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(product: Product) {
        productNameLabel.text = product.name
        priceLabel.text = product.price
        cashbackLabel.text = product.cashback
        campaignNameLabel.text = product.campaignName
        NetworkManager.shared.getImageFrom(url: product.imageUrls[0]) { [weak self] data in
            self?.imageProduct.image = UIImage(data: data)
        }
        
    }
    
}
