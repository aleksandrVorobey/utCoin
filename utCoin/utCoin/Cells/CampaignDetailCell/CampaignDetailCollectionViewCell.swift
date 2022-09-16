//
//  CampaignDetailCollectionViewCell.swift
//  utCoin
//
//  Created by admin on 15.09.2022.
//

import UIKit

class CampaignDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageURL: UIImageView!
    
    static let identifier = "CampaignDetailCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CampaignDetailCollectionViewCell", bundle: nil)
    }
    
    func setupCell(for modelProduct: Product, indexPath: IndexPath) {
        NetworkManager.shared.getImageFrom(url: modelProduct.imageUrls[indexPath.item]) { [weak self] data in
            self?.imageURL.image = UIImage(data: data)
        }
    }
    
    func setupCell(for modelCampaign: Campaign) {
        NetworkManager.shared.getImageFrom(url: modelCampaign.imageUrl) { [weak self] data in
            self?.imageURL.image = UIImage(data: data)
        }
    }

}
