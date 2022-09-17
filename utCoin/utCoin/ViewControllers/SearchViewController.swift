//
//  SearchViewController.swift
//  utCoin
//
//  Created by admin on 12.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dowloadButton: UIButton! = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Загрузить еще данные", for: .normal)
        return button
    }()
    
    var search: Search?
    var campaigns: [Campaign] = []
    var products: [Product] = []
    var searchText: String?
    var page = 0
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            tableView.tableFooterView = dowloadButton
            tableView.tableFooterView?.isHidden = false
            
            dowloadButton.addTarget(self, action: #selector(downloadNextPage), for: .touchUpInside)
        }
    }
    
    @objc private func downloadNextPage() {
        if search?.more == true && searchText != nil {
            page += 1
            NetworkManager.shared.fetchSearchRequest(page: page, searchText: searchText!) { result in
                switch result {
                case .success(let search):
                    self.search = search
                    self.campaigns += search.campaigns
                    self.products += search.products
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        searchText = text
        NetworkManager.shared.fetchSearchRequest(searchText: text) { result in
            switch result {
            case .success(let search):
                self.search = search
                self.campaigns = search.campaigns
                self.products = search.products
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension SearchViewController: PushViewControllerProtocol {
    func pushViewController(indexPath: IndexPath) {
        let campaignVC = CampaignViewController.instantiate()
        campaignVC.campaign = campaigns[indexPath.item]
        navigationController?.pushViewController(campaignVC, animated: true)
    }
}

