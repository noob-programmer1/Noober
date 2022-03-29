//
//  NoobView.swift
//  Noober
//
//  Created by Abhishek Agarwal on 27/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
import UIKit

class NoobLabel: UILabel {

    init(text: String? = nil, textColor: UIColor = UIColor.black, font: UIFont = UIFont.preferredFont(forTextStyle: .caption1), textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1, adjustFontSizeToFitWidth: Bool = false, alpha: CGFloat = 1) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text ?? nil
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustFontSizeToFitWidth
        self.alpha = alpha
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(gestureRecognizer)
      self.isUserInteractionEnabled = true
    }

    override var canBecomeFirstResponder: Bool {
           return true
       }

       override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
           return action == #selector(copy(_:))
       }

       // MARK: - UIResponderStandardEditActions

       override func copy(_ sender: Any?) {
           UIPasteboard.general.string = text
       }

       // MARK: - Long-press Handler

       @objc func handleLongPress(_ recognizer: UIGestureRecognizer) {
           if recognizer.state == .began,
               let recognizerView = recognizer.view,
               let recognizerSuperview = recognizerView.superview {
               recognizerView.becomeFirstResponder()
               UIMenuController.shared.setTargetRect(recognizerView.frame, in: recognizerSuperview)
               UIMenuController.shared.setMenuVisible(true, animated: true)
           }
       }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
