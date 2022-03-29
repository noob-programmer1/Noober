//
//  HeaderFileView.swift
//  Noober
//
//  Created by Abhishek Agarwal on 27/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
import UIKit

class HeaderFileView: UIView {

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let keyLabel = NoobLabel(textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let valueLabel = NoobLabel(textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline))

     init(key: String = "", value: String = "") {
         super.init(frame: .zero)
         translatesAutoresizingMaskIntoConstraints = false

         addSubview(contentView)
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)

        NSLayoutConstraint.activate([

            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            keyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            keyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            keyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            valueLabel.leadingAnchor.constraint(equalTo: keyLabel.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: keyLabel.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)

        ])

         updateview(key: key, value: value)
    }

    func updateview(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
