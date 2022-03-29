//
//  ApiRequestCell.swift
//  Noober
//
//  Created by Abhishek Agarwal on 27/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
import UIKit

class ApiRequestCell: UITableViewCell {
    public static let reuseIdentifier = "ApiRequestCell"
    private let responseStatus = NoobLabel(textColor: .white)
    private let responseTime = NoobLabel(textColor: .gray)
    private let requestURl = NoobLabel(textColor: .black, numberOfLines: 0)
    private let requestType = NoobLabel(textColor: .gray)
    private let contentType = NoobLabel(textColor: .gray)

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white

        contentView.addSubview(responseStatus)
        contentView.addSubview(responseTime)
        contentView.addSubview(requestURl)
        contentView.addSubview(requestType)
        contentView.addSubview(contentType)

        NSLayoutConstraint.activate([
            responseStatus.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            responseStatus.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            responseTime.leadingAnchor.constraint(equalTo: responseStatus.leadingAnchor),
            responseTime.topAnchor.constraint(equalTo: responseStatus.bottomAnchor, constant: 3),
            responseTime.widthAnchor.constraint(equalToConstant: 35),
            responseStatus.widthAnchor.constraint(equalToConstant: 35),

            requestURl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 47),
            requestURl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            requestURl.topAnchor.constraint(equalTo: responseStatus.topAnchor),

            requestType.leadingAnchor.constraint(equalTo: requestURl.leadingAnchor),
            requestType.topAnchor.constraint(equalTo: requestURl.bottomAnchor, constant: 3),

            contentType.topAnchor.constraint(equalTo: requestType.topAnchor),
            contentType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentType.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutViewWith(_ model: HTTPRequestModel) {
        responseTime.text = model.responseTime
        responseStatus.text = "\(model.responseStatus ?? 0)"

        if model.responseStatus == -1 {
            responseStatus.textColor = .gray
            responseStatus.text = "Mocked"
        } else if model.isSuccessful() {
            responseStatus.textColor = .green
        } else {
            responseStatus.textColor = .red
        }

        requestURl.text = model.requestURL
        requestType.text = model.requestMethod
        contentType.text = model.shortType
    }

}
