//
//  CampaignViewController.swift
//  utCoin
//
//  Created by admin on 14.09.2022.
//

import UIKit

class CampaignViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var product: Product?
    var campaign: Campaign?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(CampaignDetailTableViewCell.nib(), forCellReuseIdentifier: CampaignDetailTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CampaignViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CampaignDetailTableViewCell.identifier, for: indexPath) as! CampaignDetailTableViewCell
        
        if product != nil {
            cell.setupCell(for: product!)
            cell.modelProduct = product
            cell.delegate = self
        } else {
            cell.setupCell(for: campaign!)
            cell.modelCampaign = campaign
            cell.delegate = self
        }
        return cell
    }
}

extension CampaignViewController: TableCellUpdateProtocol {
    func reloadCell() {
        tableView.reloadData()
    }
}
