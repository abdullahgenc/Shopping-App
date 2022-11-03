//
//  SearchViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 2.11.2022.
//

import UIKit
import Kingfisher

final class SearchViewController: SAViewController {
    
    // MARK: - Properties
    private let mainView = SearchView()
    private var viewModel: SearchViewModel
    private let scopeTitles = ["Electronics", "Jewelery", "Men's Clothing", "Women's Clothing"]
    private var productList = [Int : Product]()
    private var searchList = [Product]()
    private var currentScope = "electronics"
    private var isSearchActive = false

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        mainView.setTableViewDelegate(self, andDataSource: self)
        title = "Search"
        navigationItem.titleView?.isHidden = true
        setupSearchController()
        
        viewModel.changeHandler = {change in
            switch change {
            case .didFetchList:
                self.mainView.refresh()
            case .didErrorOccurred(let error):
                self.showError(error)
            }
        }
        viewModel.fetchCategory(category: currentScope)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Clothes, Devices..."
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = scopeTitles
        navigationItem.searchController = searchController
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        if !isSearchActive {
            detailViewController.product = viewModel.productForIndexPath(indexPath)
        } else {
            detailViewController.product = searchList[indexPath.row]
        }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearchActive {
            return viewModel.numberOfItems
        } else {
            return searchList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell

        if !isSearchActive {
            guard let product = viewModel.productForIndexPath(indexPath),
                  let image = product.image,
                  let id = product.id
            else {
                fatalError("product not found")
            }
            productList[id] = product
            cell.productImageView.kf.setImage(with: URL(string: image))
            cell.title = product.title
        } else {
            cell.productImageView.kf.setImage(with: URL(string: searchList[indexPath.row].image!))
            cell.title = searchList[indexPath.row].title
        }
        
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased(), text.count > 1 {
            isSearchActive = true
            searchList = []
            for (_, product) in productList {
                guard let title = product.title?.lowercased(),
                      let desc = product.productDescription?.lowercased(),
                      let category = product.category?.rawValue
                else { return }
                
                if category == currentScope && (desc.contains(text) || title.contains(text)) {
                    searchList.append(product)
                }
            }
        } else {
            isSearchActive = false
            viewModel.fetchCategory(category: currentScope)
        }
        mainView.refresh()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        currentScope = scopeTitles[selectedScope].lowercased()
        viewModel.fetchCategory(category: currentScope)
    }
}
