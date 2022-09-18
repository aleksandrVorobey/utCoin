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
    @IBOutlet weak var expandButton: UIButton!
    
    var modelProduct: Product?
    var modelCampaign: Campaign?
    
    var openClose: Bool = false
    
    var delegate: TableCellUpdateProtocol?
    
    static let identifier = "CampaignDetailTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CampaignDetailTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        setupButton()
    }
    
    private func setupButton() {
        expandButton.setTitle("Развернуть", for: .normal)
        expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView.register(CampaignDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: CampaignDetailCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func expandTapped(_ sender: Any) {
        if openClose {
            expandButton.setTitle("Развернуть", for: .normal)
            expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            openClose.toggle()
            delegate?.reloadCell()
        } else {
            expandButton.setTitle("Свернуть", for: .normal)
            expandButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            openClose.toggle()
            delegate?.reloadCell()
        }
    }
    
    //MARK: - setup cell Product
    func setupCell(for model: Product) {
        nameLabel.text = model.name
        nameCampaignLabel.text = model.campaignName
        priceLabel.text = model.price
        cashbackLabel.text = model.cashback
        paymentTimeLabel.text = model.paymentTime
        let action = model.actions.first
        
        var fullActionsText = ""
        var rangeIndexArray: [NSRange] = []
        var startIndexRange = 0
        
        if model.actions.count > 1 {
            model.actions.forEach { action in
                fullActionsText += action.value + " " + action.text + "\n"
                let range = NSMakeRange(startIndexRange, (action.value.count))
                rangeIndexArray.append(range)
                startIndexRange = fullActionsText.count
            }
        }
        
        if openClose {
            actionsLabel.attributedText = attributedString(for: fullActionsText, range: rangeIndexArray)
        } else {
            let text = (action?.value ?? "") + " " +  (action?.text ?? "")
            let range = NSMakeRange(0, action?.value.count ?? 0)
            actionsLabel.attributedText = attributedString(for: text, range: [range])
        }
        
    }
    
    //MARK: - setup cell Campaign
    func setupCell(for model: Campaign) {
        let height = namePriceView.heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
        
        nameLabel.text = model.name
        cashbackLabel.text = model.cashback
        paymentTimeLabel.text = model.paymentTime
        let action = model.actions.first
        
        var fullActionsText = ""
        var rangeIndexArray: [NSRange] = []
        var startIndexRange = 0
        
        if model.actions.count > 1 {
            model.actions.forEach { action in
                fullActionsText += action.value + " " + action.text + "\n"
                let range = NSMakeRange(startIndexRange, (action.value.count))
                rangeIndexArray.append(range)
                startIndexRange = fullActionsText.count
            }
        }
        
        if openClose {
            actionsLabel.attributedText = attributedString(for: fullActionsText, range: rangeIndexArray)
        } else {
            let text = (action?.value ?? "") + " " +  (action?.text ?? "")
            let range = NSMakeRange(0, action?.value.count ?? 0)
            actionsLabel.attributedText = attributedString(for: text, range: [range])
        }
        
    }
    
    private func attributedString(for text: String, range: [NSRange]) -> NSAttributedString {
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.purple]
        let attributedString = NSMutableAttributedString(string: text)
        
        range.forEach({attributedString.setAttributes(textAttribute, range: $0)})
        return attributedString
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
