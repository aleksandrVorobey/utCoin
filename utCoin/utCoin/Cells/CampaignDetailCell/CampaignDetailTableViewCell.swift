//
//  CampaignDetailTableViewCell.swift
//  utCoin
//
//  Created by admin on 14.09.2022.
//

import UIKit

protocol TableCellUpdateProtocol {
    func reloadCell()
}

class CampaignDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var namePriceView: UIView!
    @IBOutlet weak var actionsLabel: UILabel!
    @IBOutlet weak var cashbackLabel: UILabel!
    @IBOutlet weak var nameCampaignLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paymentTimeLabel: UILabel!
    
    var modelProduct: Product?
    var modelCampaign: Campaign?
    
    var heightAnchorView: NSLayoutConstraint!
    var openClose: Bool = false
    
    var delegate: TableCellUpdateProtocol?
    
    static let identifier = "CampaignDetailTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CampaignDetailTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(CampaignDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: CampaignDetailCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func expandTapped(_ sender: Any) {
        print(#function)
        if openClose {
            openClose.toggle()
            delegate?.reloadCell()
        } else {
            openClose.toggle()
            delegate?.reloadCell()
        }
    }
    
    func setupCell(for model: Product) {
        nameLabel.text = model.name
        nameCampaignLabel.text = model.campaignName
        priceLabel.text = model.price
        cashbackLabel.text = model.cashback
        paymentTimeLabel.text = model.paymentTime
        let action = model.actions.first
        
        var fullActionsText = ""
        
        if model.actions.count > 1 {
            model.actions.forEach { action in
                fullActionsText += action.value + " " + action.text + "\n"
            }
        }
        
        if openClose {
            actionsLabel.text = fullActionsText
        } else {
            let text = (action?.value ?? "") + " " +  (action?.text ?? "")
            actionsLabel.text = text
        }
        
    }
    
    func setupCell(for model: Campaign) {
        let height = namePriceView.heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
        
        nameLabel.text = model.name
        cashbackLabel.text = model.cashback
        paymentTimeLabel.text = model.paymentTime
        let action = model.actions.first
        
        var fullActionsText = ""
        
        if model.actions.count > 1 {
            model.actions.forEach { action in
                fullActionsText += action.value + " " + action.text + "\n"
            }
        }
        
        if openClose {
            actionsLabel.text = fullActionsText
        } else {
            let text = (action?.value ?? "") + " " +  (action?.text ?? "")
            actionsLabel.text = text
        }
        
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CampaignDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if modelProduct != nil {
            return modelProduct?.imageUrls.count ?? 0
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CampaignDetailCollectionViewCell.identifier, for: indexPath) as! CampaignDetailCollectionViewCell
        if modelProduct != nil {
            cell.setupCell(for: modelProduct!, indexPath: indexPath)
            pageControl.numberOfPages = modelProduct?.imageUrls.count ?? 0
        } else {
            cell.setupCell(for: modelCampaign!)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(page)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CampaignDetailTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
