//
//  ApiRequestViewController.swift
//  Noober
//
//  Created by Abhishek Agarwal on 27/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import UIKit

public enum ControllerType {
    case request
    case response
}

class ApiRequestViewController: UIViewController {

    private let headerLabel = NoobLabel(text: "Headers", textColor: .red, font: UIFont.preferredFont(forTextStyle: .headline))
    private let bodyTxtLabel = NoobLabel(text: "Request Body", textColor: .red, font: UIFont.preferredFont(forTextStyle: .headline))
    private let bodyLabel = NoobLabel(textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)

    public let model: HTTPRequestModel
    public let type: ControllerType

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        view.distribution = .equalSpacing
        return view
    }()

    private lazy var containerView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(model: HTTPRequestModel, type: ControllerType) {
        self.model = model
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupView()

    }

    private func setupView() {

        view.addSubview(containerView)

        containerView.addSubview(headerLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(bodyTxtLabel)
        containerView.addSubview(stackView)

        if type == .request {
            model.requestHeaders?.forEach({ header in
                if !header.key.isEmpty && !header.value.isEmpty {
                    stackView.addArrangedSubview(HeaderFileView(key: header.key, value: header.value))
                }
            })
        } else {
            model.responseHeaders?.forEach({ header in
                if !header.key.isEmpty && !header.value.isEmpty {
                    stackView.addArrangedSubview(HeaderFileView(key: header.key, value: header.value))
                }
            })
        }

        bodyLabel.text = type == .request ? model.requestbody  : model.responseBody
        bodyTxtLabel.text = type == .request ? "Request Body" : "Response Body"

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            headerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),

            stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: -4),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),

            bodyTxtLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            bodyTxtLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            bodyTxtLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),

            bodyLabel.topAnchor.constraint(equalTo: bodyTxtLabel.bottomAnchor, constant: 4),
            bodyLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            bodyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20)
        ])

    }

}
