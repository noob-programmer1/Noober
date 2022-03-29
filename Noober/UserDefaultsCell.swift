//
//  UserDefaultsCell.swift
//  Noober
//
//  Created by Abhishek Agarwal on 28/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsCell: UITableViewCell {

    public static let reuseIdentifier = "UserDefaultsCell"
    private let userdefaultsView = HeaderFileView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white

        contentView.addSubview(userdefaultsView)

        NSLayoutConstraint.activate([
            userdefaultsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userdefaultsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userdefaultsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            userdefaultsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)

        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutViewWith(key: String, value: String) {
        userdefaultsView.updateview(key: key, value: value)
    }

}
