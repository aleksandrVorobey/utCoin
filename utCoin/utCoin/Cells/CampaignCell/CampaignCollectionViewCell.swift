//
//  CampaignCollectionViewCell.swift
//  utCoin
//
//  Created by admin on 14.09.2022.
//

import UIKit

class CampaignCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var campaignImageView: UIImageView!
    @IBOutlet weak var cashbackLabel: UILabel!
    
    static let identifier = "CampaignCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CampaignCollectionViewCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.campaignImageView.image = nil
    }
    
    func setupCell(model: Campaign) {
        cashbackLabel.text = model.cashback
        NetworkManager.shared.getImageFrom(url: model.imageUrl) { [weak self] data in
            self?.campaignImageView.image = UIImage(data: data)
        }
    }
}
