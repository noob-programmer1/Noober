//
//  UserDefaultsViewController.swift
//  Noober
//
//  Created by Abhishek Agarwal on 26/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import UIKit

class UserDefaultsViewController: UITableViewController {

    private lazy var userdefaults = UserDefaults.standard.dictionaryRepresentation()
    private var rowUserdefaultsList = [RequestHeaders]()
    private var userdefaultsList = [RequestHeaders]()
    private var query = ""

    private lazy var searchViewController: UISearchController = {
        return UISearchController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.searchController = searchViewController

        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.definesPresentationContext = true
        searchViewController.searchBar.placeholder = "Search for key or value"

        updateData()

        tableView.register(UserDefaultsCell.self, forCellReuseIdentifier: UserDefaultsCell.reuseIdentifier)
    }

    private func updateData() {
        userdefaults.forEach { (key, value) in
            rowUserdefaultsList.append(RequestHeaders(key: key, value: "\(value)"))
        }
        userdefaultsList = rowUserdefaultsList
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userdefaultsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserDefaultsCell.reuseIdentifier, for: indexPath) as! UserDefaultsCell
        cell.layoutViewWith(key: userdefaultsList[indexPath.row].key, value: userdefaultsList[indexPath.row].value)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit User Defaults", message: userdefaultsList[indexPath.row].key, preferredStyle: .alert)
        alert.addTextField {  textfield in
            textfield.placeholder = self.userdefaultsList[indexPath.row].value
            textfield.font = UIFont.preferredFont(forTextStyle: .caption1)
            textfield.textColor = UIColor.black
            textfield.textAlignment = .left
        }
        let saveAction = UIAlertAction(title: "save", style: .default) { _ in
            let textField = alert.textFields![0] as UITextField

            if let text = textField.text {
                UserDefaults.standard.set(text, forKey: self.userdefaultsList[indexPath.row].key)
                self.userdefaults = UserDefaults.standard.dictionaryRepresentation()
                self.rowUserdefaultsList.removeAll()
                self.updateData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)

    }

    private func filterUserDefaults() {
        if query.isEmpty {
            userdefaultsList = rowUserdefaultsList
        } else {
            userdefaultsList = rowUserdefaultsList.filter {
                $0.key.lowercased().contains(query.lowercased()) || $0.value.lowercased().contains(query.lowercased())
            }
        }
        tableView.reloadData()

    }

}

extension UserDefaultsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        query = searchController.searchBar.text ?? ""
        filterUserDefaults()
    }

}
