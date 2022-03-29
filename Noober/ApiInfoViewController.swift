//
//  ApiInfoViewController.swift
//  Noober
//
//  Created by Abhishek Agarwal on 27/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import UIKit

class ApiInfoViewController: UIViewController {

    private let urlTxtLabel = NoobLabel(text: "URL", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let cUrlTxtLabel = NoobLabel(text: "cURL", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let methodTxtLabel = NoobLabel(text: "Method", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let statusTxtLabel = NoobLabel(text: "Status Code", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let requestDateTxtLabel = NoobLabel(text: "Request Date", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let responseDateTxtLabel = NoobLabel(text: "Response Date", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let timeIntervalTxtLabel = NoobLabel(text: "Time Interval", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let timeoutTxtLabel = NoobLabel(text: "Timeout", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let cacheTxtLabel = NoobLabel(text: "Cache", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))

    private let urlLabel = NoobLabel(textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let cUrlLabel = NoobLabel(textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let methodLabel = NoobLabel(textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let statusLabel = NoobLabel( textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let requestDateLabel = NoobLabel( textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let responseDateLabel = NoobLabel(textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let timeIntervalLabel = NoobLabel( textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let timeoutLabel = NoobLabel( textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)
    private let cacheLabel = NoobLabel(textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline), numberOfLines: 0)

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public var selectedModel: HTTPRequestModel

    init(model: HTTPRequestModel) {
        self.selectedModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        view.addSubview(scrollView)

        scrollView.addSubview(cUrlLabel)
        scrollView.addSubview(cUrlTxtLabel)
        scrollView.addSubview(statusLabel)
        scrollView.addSubview(statusTxtLabel)
        scrollView.addSubview(methodLabel)
        scrollView.addSubview(methodTxtLabel)
        scrollView.addSubview(urlLabel)
        scrollView.addSubview(urlTxtLabel)
        scrollView.addSubview(responseDateLabel)
        scrollView.addSubview(responseDateTxtLabel)
        scrollView.addSubview(requestDateLabel)
        scrollView.addSubview(requestDateTxtLabel)
        scrollView.addSubview(timeoutLabel)
        scrollView.addSubview(timeoutTxtLabel)
        scrollView.addSubview(timeIntervalLabel)
        scrollView.addSubview(timeIntervalTxtLabel)
        scrollView.addSubview(cacheLabel)
        scrollView.addSubview(cacheTxtLabel)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            cUrlTxtLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            cUrlTxtLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cUrlLabel.topAnchor.constraint(equalTo: cUrlTxtLabel.bottomAnchor, constant: 4),
            cUrlLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            cUrlLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),

            statusTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            statusTxtLabel.topAnchor.constraint(equalTo: cUrlLabel.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: statusTxtLabel.bottomAnchor, constant: 4),

            methodTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            methodTxtLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
            methodLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            methodLabel.topAnchor.constraint(equalTo: methodTxtLabel.bottomAnchor, constant: 4),

            urlTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            urlTxtLabel.topAnchor.constraint(equalTo: methodLabel.bottomAnchor, constant: 12),
            urlLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            urlLabel.topAnchor.constraint(equalTo: urlTxtLabel.bottomAnchor, constant: 4),
            urlLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),

            requestDateTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            requestDateTxtLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 12),
            requestDateLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            requestDateLabel.topAnchor.constraint(equalTo: requestDateTxtLabel.bottomAnchor, constant: 4),

            responseDateTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            responseDateTxtLabel.topAnchor.constraint(equalTo: requestDateLabel.bottomAnchor, constant: 12),
            responseDateLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            responseDateLabel.topAnchor.constraint(equalTo: responseDateTxtLabel.bottomAnchor, constant: 4),

            timeIntervalTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            timeIntervalTxtLabel.topAnchor.constraint(equalTo: responseDateLabel.bottomAnchor, constant: 12),
            timeIntervalLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            timeIntervalLabel.topAnchor.constraint(equalTo: timeIntervalTxtLabel.bottomAnchor, constant: 4),

            timeoutTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            timeoutTxtLabel.topAnchor.constraint(equalTo: timeIntervalLabel.bottomAnchor, constant: 12),
            timeoutLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            timeoutLabel.topAnchor.constraint(equalTo: timeoutTxtLabel.bottomAnchor, constant: 4),

            cacheTxtLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            cacheTxtLabel.topAnchor.constraint(equalTo: timeoutLabel.bottomAnchor, constant: 12),
            cacheLabel.leadingAnchor.constraint(equalTo: cUrlTxtLabel.leadingAnchor),
            cacheLabel.topAnchor.constraint(equalTo: cacheTxtLabel.bottomAnchor, constant: 4),
            cacheLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20)

        ])

        cUrlLabel.text = selectedModel.requestCurl
        urlLabel.text = selectedModel.requestURL
        methodLabel.text = selectedModel.requestMethod
        statusLabel.text = "\(selectedModel.responseStatus ?? 0)"
        requestDateLabel.text = "\(selectedModel.requestDate ?? Date())"
        responseDateLabel.text = "\(selectedModel.responseDate ?? Date())"
        timeIntervalLabel.text = "\(selectedModel.timeInterval ?? 0)"
        timeoutLabel.text = selectedModel.requestTimeout
        cacheLabel.text = selectedModel.requestCachePolicy

        if selectedModel.responseStatus == -1 {
            statusLabel.textColor = .gray
            statusLabel.text = "Mocked"
        } else if selectedModel.isSuccessful() {
            statusLabel.textColor = .green
        } else {
            statusLabel.textColor = .red
        }

    }

}
