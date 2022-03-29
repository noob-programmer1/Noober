//
//  ApiRequestsTableViewController.swift
//  Noober
//
//  Created by Abhishek Agarwal on 26/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import UIKit

class ApiRequestsTableViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.refreshControl = nil
        return view
    }()

    private lazy var searchViewController: UISearchController = {
        return UISearchController()
    }()

    private lazy var tabBarViewController: UITabBarController = {
        let tabController = UITabBarController()
        return tabController
    }()

    private var query: String?
    private var models = [HTTPRequestModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.register(ApiRequestCell.self, forCellReuseIdentifier: ApiRequestCell.reuseIdentifier)
        title = "API Calls"
        navigationItem.searchController = searchViewController
        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.definesPresentationContext = true
        searchViewController.searchBar.placeholder = "Search URL or HTTP method"
        models = NooberHttpRequestManager.shared.getModels(query)
        tabBarViewController.hidesBottomBarWhenPushed = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadData),
            name: NSNotification.Name.NoobReload,
            object: nil)
    }

    @objc private func reloadData() {
        models = NooberHttpRequestManager.shared.getModels(query)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func initTabController(model: HTTPRequestModel) {
        let  apiRequestVC = ApiRequestViewController(model: model, type: .request)
        apiRequestVC.tabBarItem = .init(title: "Request", image: UIImage.apiResponseUnselectedImage, selectedImage: UIImage.apiRequestselectedImage)

       let apiResponseVC = ApiRequestViewController(model: model, type: .response)
        apiResponseVC.tabBarItem = .init(title: "Response", image: UIImage.apiResponseUnselectedImage, selectedImage: UIImage.apiResponseSelectedImage )

        let apiInfoVC = ApiInfoViewController(model: model)
            apiInfoVC.tabBarItem = .init(title: "Info", image: UIImage.apiInfoUnselectedImage, selectedImage: UIImage.apiInfoselectedImage )

        tabBarViewController.viewControllers = [apiInfoVC, apiRequestVC, apiResponseVC]
        tabBarViewController.selectedViewController = apiInfoVC

    }
}

// MARK: - Table view data source
extension ApiRequestsTableViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApiRequestCell.reuseIdentifier, for: indexPath) as! ApiRequestCell
        cell.layoutViewWith(models[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        initTabController(model: models[indexPath.row])
              navigationController?.pushViewController(tabBarViewController, animated: true)
    }

}

extension ApiRequestsTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        query = searchController.searchBar.text
        models = NooberHttpRequestManager.shared.getModels(query)
        tableView.reloadData()
    }

}
