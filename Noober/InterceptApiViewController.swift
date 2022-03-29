//
//  InterceptApiViewController.swift
//  Noober
//
//  Created by Abhishek Agarwal on 28/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import UIKit

protocol InterceptApiViewControllerDelegate: AnyObject {
    func didTappedSubmit(response: String?)
}

class InterceptApiViewController: UIViewController {

    weak var delegate: InterceptApiViewControllerDelegate?
    private let urlTxtLabel = NoobLabel(text: "URL", textColor: .blue, font: UIFont.preferredFont(forTextStyle: .headline))
    private let urlLabel = NoobLabel(text: "URL", textColor: .black, font: UIFont.preferredFont(forTextStyle: .subheadline))
    private let url: String
    private var responseBody: String = ""

    private lazy var bodyField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .caption1)
        view.textColor = .black
        view.keyboardType = .default
        view.isEditable = true
        view.textAlignment = .left
        view.delegate = self
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var submitButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 12
        view.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.setTitle("Submit", for: .normal)
        view.addTarget(self, action: #selector(didTappedSubmit), for: .touchUpInside)
        return view
    }()

    init(url: String?, delegate: InterceptApiViewControllerDelegate, responseBody: String) {
        self.url = url ?? ""
        self.delegate = delegate
        self.responseBody = responseBody
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
        scrollView.addSubview(urlTxtLabel)
        scrollView.addSubview(urlLabel)
        scrollView.addSubview(bodyField)
        scrollView.addSubview(submitButton)
        bodyField.becomeFirstResponder()

        urlLabel.text = url
        bodyField.text = responseBody

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            urlTxtLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            urlTxtLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            urlLabel.leadingAnchor.constraint(equalTo: urlTxtLabel.leadingAnchor),
            urlLabel.topAnchor.constraint(equalTo: urlTxtLabel.bottomAnchor, constant: 4),
            urlLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            bodyField.leadingAnchor.constraint(equalTo: urlTxtLabel.leadingAnchor),
            bodyField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 10),
            bodyField.widthAnchor.constraint(equalTo: urlLabel.widthAnchor),
            bodyField.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            submitButton.leadingAnchor.constraint(equalTo: urlTxtLabel.leadingAnchor),
            submitButton.topAnchor.constraint(equalTo: bodyField.bottomAnchor, constant: 10),
            submitButton.widthAnchor.constraint(equalTo: urlLabel.widthAnchor),
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }

    @objc
    private func didTappedSubmit() {
        delegate?.didTappedSubmit(response: bodyField.text)
        dismiss(animated: true)
    }

}

extension InterceptApiViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if (textView.text?.isEmpty) ?? true {
            submitButton.setTitle("Cancel", for: .normal)
        } else {
            submitButton.setTitle("Submit", for: .normal)
        }
    }
}
