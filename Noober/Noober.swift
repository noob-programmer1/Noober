//
//  Noober.swift
//  Noober
//
//  Created by Abhishek Agarwal on 26/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
import UIKit

 public class Noob {
    public static let shared = Noob()

    private(set) var isStarted = false
    private var isLoadingForFirstTime = false
    public var ignoredURL = [String]()
    public var shakeToOpen = true
    public var interceptForURLS = [String]()
    public var mockResponseForURLs = [URL?: String]()

    private init() {}

    public func startLogging() {
        guard !isStarted else { return }

        isStarted = true
        URLProtocol.registerClass(NooberProtocol.self)
        URLSessionConfiguration.implementNoober()
    }

   public  func stopLogging() {
        guard isStarted else { return }

        isStarted = false
        URLProtocol.unregisterClass(NooberProtocol.self)
    }

    public func toogle() {
        NoobHelper.toogle()
    }

}
