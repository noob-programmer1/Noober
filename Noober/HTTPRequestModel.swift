//
//  HTTPRequestModel.swift
//  Noober
//
//  Created by Abhishek Agarwal on 26/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation

public struct HTTPRequestModel {
    public var requestURL: String?
    public var requestURLComponents: URLComponents?
    public var requestURLQueryItems: [URLQueryItem]?
    public var requestMethod: String?
    public var requestCachePolicy: String?
    public var requestDate: Date?
    public var requestTime: String?
    public var requestTimeout: String?
    public var requestHeaders: [RequestHeaders]?
    public var requestBodyLength: Int?
    public var requestType: String?
    public var requestCurl: String?
    public var requestbody: String?

    public var responseStatus: Int?
    public var responseType: String?
    public var responseDate: Date?
    public var responseTime: String?
    public var responseHeaders: [RequestHeaders]?
    public var responseBodyLength: Int?
    public var responseBody: String?

    public var timeInterval: Float?

    public var shortType: String = HTTPModelShortType.OTHER.rawValue

    public var url: String {
        guard let url = self.requestURL else {
            return "_"
        }
        return url
    }

    public var method: String {
        guard let method = self.requestMethod else {
            return "_"
        }
        return method
    }

    mutating func saveRequest(_ request: URLRequest) {
        requestDate = Date()
        requestTime = getTimeFromDate(requestDate!)
        requestURL = request.getURL()
        requestURLComponents = request.getURLComponents()
        requestURLQueryItems = request.getURLComponents()?.queryItems
        requestMethod = request.getHttpMethod()
        requestCachePolicy = request.getCachePolicy()
        requestTimeout = request.getTimeout()
        requestHeaders = request.getHeaders()
        requestType = requestHeaders?.filter {$0.key == "Content-Type"}.first?.value
        requestCurl = request.getCurl()
        let data = request.getBody()
        requestbody = prettyOutput(data)
        self.requestBodyLength = data.count
    }

    mutating func saveErrorResponse() {
        responseDate = Date()
    }

    mutating func saveResponse(_ response: URLResponse?, data: Data) {

        responseDate = Date()
        timeInterval = Float(responseDate!.timeIntervalSince(requestDate!))
        saveResponseBodyData(data)
        responseTime = getTimeFromDate(responseDate!)

        guard let response = response else {
            responseStatus = -1
            return
        }

        responseStatus = response.getStatus()
        responseHeaders = response.getHeaders()

        let headers = response.getHeaders()

        if let contentType = headers.filter({$0.key == "Content-Type"}).first?.value {
            responseType = contentType.components(separatedBy: ";")[0]
            shortType = getShortTypeFrom(responseType!).rawValue as String
        }
    }

    mutating func saveResponseBodyData(_ data: Data) {
        var bodyString: String?

        if shortType as String == HTTPModelShortType.IMAGE.rawValue {
            bodyString = data.base64EncodedString(options: .endLineWithLineFeed) as String?

        } else {
            if let tempBodyString = String.init(data: data, encoding: String.Encoding.utf8) {
                bodyString = tempBodyString
            }
        }

        if let responseBody = bodyString {
            responseBodyLength = data.count
            self.responseBody = responseBody
        }

    }

    fileprivate func prettyOutput(_ rawData: Data, contentType: String? = nil) -> String {
        if let contentType = contentType {
            let shortType = getShortTypeFrom(contentType)
            if let output = prettyPrint(rawData, type: shortType) {
                return output as String
            }
        }
        return String(data: rawData, encoding: String.Encoding.utf8) ?? ""
    }

    public func getTimeFromDate(_ date: Date) -> String? {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute], from: date)
        guard let hour = components.hour, let minutes = components.minute else {
            return nil
        }
        if minutes < 10 {
            return "\(hour):0\(minutes)"
        } else {
            return "\(hour):\(minutes)"
        }
    }

    public func getShortTypeFrom(_ contentType: String) -> HTTPModelShortType {
        if NSPredicate(format: "SELF MATCHES %@",
                       "^application/(vnd\\.(.*)\\+)?json$").evaluate(with: contentType) {
            return .JSON
        }

        if (contentType == "application/xml") || (contentType == "text/xml") {
            return .XML
        }

        if contentType == "text/html" {
            return .HTML
        }

        if contentType.hasPrefix("image/") {
            return .IMAGE
        }

        return .OTHER
    }

    public func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> String? {
        switch type {
        case .JSON:
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: rawData, options: [])
                let prettyPrintedString = try JSONSerialization.data(withJSONObject: rawJsonData, options: [.prettyPrinted])
                return String(data: prettyPrintedString, encoding: String.Encoding.utf8)
            } catch {
                return nil
            }

        default:
            return nil

        }
    }

    public func isSuccessful() -> Bool {
        if (self.responseStatus != nil) && (self.responseStatus ?? -1 < 400) {
            return true
        } else {
            return false
        }
    }

    public func formattedRequestLogEntry() -> String {
        var log = String()

        if let requestURL = self.requestURL {
            log.append("----------------- \(requestURL) -------\n")
        }

        if let requestMethod = self.requestMethod {
            log.append("Request Method -> \(requestMethod)\n")
        }

        if let requestDate = self.requestDate {
            log.append("Request Date -> \(requestDate)\n")
        }

        if let requestTime = self.requestTime {
            log.append("Request Time -> \(requestTime)\n")
        }

        if let requestType = self.requestType {
            log.append("Request Type -> \(requestType)\n")
        }

        if let requestTimeout = self.requestTimeout {
            log.append("Request Timeout -> \(requestTimeout)\n")
        }

        if let requestHeaders = self.requestHeaders {
            log.append("Request Headers -> \n\(requestHeaders)\n")
        }

         log.append("Request Body -> \n \(requestbody ?? "")\n")

            log.append("-------END REQUEST -------\n\n")

        return log
    }

    public func formattedResponseLogEntry() -> String {
        var log = String()

        if let requestURL = self.requestURL {
            log.append("-------\(requestURL) -------\n")
        }

        if let responseStatus = self.responseStatus {
            log.append("Response Status ->  \(responseStatus)\n")
        }

        if let responseType = self.responseType {
            log.append("Response Type ->  \(responseType)\n")
        }

        if let responseDate = self.responseDate {
            log.append("Response Date ->  \(responseDate)\n")
        }

        if let responseTime = self.responseTime {
            log.append("Response Time ->  \(responseTime)\n")
        }

        if let responseHeaders = self.responseHeaders {
            log.append("Response Headers -> \n\(responseHeaders)\n\n")
        }

         log.append("Response Body -> \n \(responseBody ?? "")\n")

            log.append("-------END RESPONSE --------\n\n")

        return log
    }
}
