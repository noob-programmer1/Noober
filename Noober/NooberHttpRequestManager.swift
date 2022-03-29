//
//  NooberHttpRequestManager.swift
//  Noober
//
//  Created by Abhishek Agarwal on 26/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
class NooberHttpRequestManager {
    public static let shared = NooberHttpRequestManager()

    private init() {}

    private var models = [HTTPRequestModel]()
    private let syncQueue = DispatchQueue(label: "Noober", qos: .utility)

    func add(_ model: HTTPRequestModel) {
        syncQueue.async {
            self.models.insert(model, at: 0)
            NotificationCenter.default.post(name: .NoobReload, object: nil)
        }
    }

    func clear() {
        syncQueue.async {
            self.models.removeAll()
            NotificationCenter.default.post(name: .NoobReload, object: nil)
        }
    }

    func getModels(_ searchedText: String? = nil) -> [HTTPRequestModel] {

        guard let query = searchedText, !query.isEmpty else {
            return models
        }

        return models.filter {$0.url.lowercased().contains(query.lowercased()) || $0.method.lowercased().contains(query.lowercased())}
    }

}
