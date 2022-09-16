//
//  SearchViewController.swift
//  utCoin
//
//  Created by admin on 12.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var campaigns: [Campaign] = []
    var products: [Product] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите ваш запрос"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductTableViewCell.nib(), forCellReuseIdentifier: ProductTableViewCell.identifier)
        tableView.register(CampaignTableViewCell.nib(), forCellReuseIdentifier: CampaignTableViewCell.identifier)
    }
    
    private func searchTextRequest(searchText: String) {
        NetworkManager.shared.fetchSearchRequest(searchText: searchText) { result in
            switch result {
            case .success(let search):
                self.campaigns = search.campaigns
                self.products = search.products
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return campaigns.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !campaigns.isEmpty  {
            return 1
        } else {
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && !campaigns.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: CampaignTableViewCell.identifier, for: indexPath) as! CampaignTableViewCell
            cell.delegate = self
            cell.models = campaigns
            cell.collectionView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
            let product = products[indexPath.row]
            cell.setupCell(product: product)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let campaignVC = CampaignViewController.instantiate()
        campaignVC.product = products[indexPath.row]
        navigationController?.pushViewController(campaignVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        let textForUrl = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        searchTextRequest(searchText: textForUrl)
    }
}


extension SearchViewController: PushViewControllerProtocol {
    func pushViewController(indexPath: IndexPath) {
        let campaignVC = CampaignViewController.instantiate()
        campaignVC.campaign = campaigns[indexPath.item]
        navigationController?.pushViewController(campaignVC, animated: true)
    }
}
