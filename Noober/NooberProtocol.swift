//
//  NooberProtocol.swift
//  Noober
//
//  Created by Abhishek Agarwal on 26/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation

open class NooberProtocol: URLProtocol {
    static let NoobKey = "Noober_Protocol"

    private lazy var session: URLSession = { [unowned self] in
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()

    private var model = HTTPRequestModel()
    private var response: URLResponse?
    private var responseData: NSMutableData?

    override open class func canInit(with request: URLRequest) -> Bool {
        return canServeRequest(request)
    }

    override open class func canInit(with task: URLSessionTask) -> Bool {
        guard let request = task.currentRequest else { return false }
        return canServeRequest(request)
    }

    private class func canServeRequest(_ request: URLRequest) -> Bool {
        guard Noob.shared.isStarted else {
            return false
        }

        guard URLProtocol.property(forKey: NooberProtocol.NoobKey, in: request) == nil,
              let url = request.url, (url.absoluteString.hasPrefix("http") || url.absoluteString.hasPrefix("https")) else {
                  return false
              }

        let absoluteString = url.absoluteString
        guard !Noob.shared.ignoredURL.contains(where: { absoluteString.hasPrefix($0) }) else {
            return false
        }
        return true
    }

    override open func startLoading() {
        model.saveRequest(request)
        let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: NooberProtocol.NoobKey, in: mutableRequest)

        if let mockedResponse = Noob.shared.mockResponseForURLs[request.url] {
            mockResponse(mockResponse: mockedResponse)
        } else {
            session.dataTask(with: mutableRequest as URLRequest).resume()
        }

    }

    override open func stopLoading() {
        session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
        }
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}

extension NooberProtocol: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if Noob.shared.interceptForURLS.filter({$0 == request.url?.absoluteString}).first != nil {
            presentVC(url: request.url?.absoluteString, responseBody: String(data: data, encoding: .utf8) ?? "")
        } else {
            responseData?.append(data)
            client?.urlProtocol(self, didLoad: data)
        }
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.response = response
        responseData = NSMutableData()
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if Noob.shared.interceptForURLS.filter({$0 == request.url?.absoluteString}).first == nil {
            defer {
                if let error = error {
                    client?.urlProtocol(self, didFailWithError: error)
                } else {
                    client?.urlProtocolDidFinishLoading(self)
                }
            }

            debugPrint(model.formattedRequestLogEntry())
            debugPrint(model.formattedResponseLogEntry())

            if error != nil {
                model.saveErrorResponse()
            } else if let response = response {
                let data = (responseData ?? NSMutableData()) as Data
                model.saveResponse(response, data: data)
            }

            NooberHttpRequestManager.shared.add(model)
        }

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {

        let updatedRequest: URLRequest
        if URLProtocol.property(forKey: NooberProtocol.NoobKey, in: request) != nil {
            let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
            URLProtocol.removeProperty(forKey: NooberProtocol.NoobKey, in: mutableRequest)

            updatedRequest = mutableRequest as URLRequest
        } else {
            updatedRequest = request
        }

        client?.urlProtocol(self, wasRedirectedTo: updatedRequest, redirectResponse: response)
        completionHandler(updatedRequest)
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let wrappedChallenge = URLAuthenticationChallenge(authenticationChallenge: challenge, sender: NooberAuthenticationManager(handler: completionHandler))
        client?.urlProtocol(self, didReceive: wrappedChallenge)
    }

}

extension NooberProtocol: InterceptApiViewControllerDelegate {

    func didTappedSubmit(response: String?) {
        guard let mockedResponse = response else {
            return
        }
        mockResponse(mockResponse: mockedResponse)

    }
}

extension NooberProtocol {

    private func presentVC(url: String?, responseBody: String) {
        DispatchQueue.main.async {
            let vc = InterceptApiViewController(url: url, delegate: self, responseBody: responseBody)
            NoobHelper.presentingViewController?.present(vc, animated: true, completion: nil)
        }
    }

    private func mockResponse(mockResponse: String) {
        DispatchQueue.global(qos: .utility).async {
            let data = Data(mockResponse.utf8)
            self.responseData = NSMutableData()
            self.responseData?.append(data)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
            self.model.saveResponse(self.response, data: data)
            NooberHttpRequestManager.shared.add(self.model)
        }

    }
}
