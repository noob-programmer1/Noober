//
//  Extension.swift
//  Noober
//
//  Created by Abhishek Agarwal on 26/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
import UIKit

public enum HTTPModelShortType: String {
    case JSON = "JSON"
    case XML = "XML"
    case HTML = "HTML"
    case IMAGE = "Image"
    case OTHER = "Other"

    static let allValues = [JSON, XML, HTML, IMAGE, OTHER]
}

public struct RequestHeaders {
    let key: String
    let value: String
}

extension URLRequest {
    func getURL() -> String {
        guard let url = self.url else {
            return ""
        }
        return url.absoluteString
    }

    func getURLComponents() -> URLComponents? {
        guard let url = self.url else {
            return nil
        }
        return URLComponents(string: url.absoluteString)
    }

    func getHttpMethod() -> String {

        guard let method = self.httpMethod else {
            return ""
        }
        return method
    }

    func getCachePolicy() -> String {
        switch cachePolicy {
        case .useProtocolCachePolicy: return "UseProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData: return "ReloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData: return "ReloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad: return "ReturnCacheDataElseLoad"
        case .returnCacheDataDontLoad: return "ReturnCacheDataDontLoad"
        case .reloadRevalidatingCacheData: return "ReloadRevalidatingCacheData"
        @unknown default: return "Unknown \(cachePolicy)"
        }
    }

    func getTimeout() -> String {
        return String(Double(timeoutInterval))
    }

    func getHeaders() -> [RequestHeaders] {
        var headers = [RequestHeaders]()
        if let httpHeaders = allHTTPHeaderFields {

            httpHeaders.forEach { (key, value) in
                headers.append(RequestHeaders(key: key, value: value))
            }

        }
        return headers
    }

    func getBody() -> Data {

        guard let bodyStream = self.httpBodyStream else { return Data() }

        bodyStream.open()
        let bufferSize: Int = 16

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

        var dat = Data()

        while bodyStream.hasBytesAvailable {

            let readDat = bodyStream.read(buffer, maxLength: bufferSize)
            dat.append(buffer, count: readDat)
        }

        buffer.deallocate()

        bodyStream.close()

        return dat
    }

    func getCurl() -> String {
        guard let url = url else { return "" }
        let baseCommand = "curl \(url.absoluteString)"

        var command = [baseCommand]

        if let method = httpMethod {
            command.append("-X \(method)")
        }

        getHeaders().forEach { header in
            command.append("-H \u{22}\(header.key): \(header.value)\u{22}")
        }

        if let body = String(data: getBody(), encoding: .utf8) {
            command.append("-d \u{22}\(body)\u{22}")
        }

        return command.joined(separator: " ")
    }
}

extension URLResponse {
    func getStatus() -> Int {
        return (self as? HTTPURLResponse)?.statusCode ?? 999
    }

    func getHeaders() -> [RequestHeaders] {
        var headers = [RequestHeaders]()
        if let httpHeaders =  (self as? HTTPURLResponse)?.allHeaderFields {
            httpHeaders.forEach { (key, value) in
                headers.append(RequestHeaders(key: "\(key)", value: "\(value)"))
            }
        }
        return headers
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        return compare(dateToCompare) == ComparisonResult.orderedDescending
    }
}

extension NSNotification.Name {
    static let NoobReload = Notification.Name("NoobReload")
}

extension String {

    func getData() -> Data {
        return Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) ?? Data()
    }
}

extension UIImage {

    static  var apiRequestUnselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAABYElEQVRIie3WMUscQRiA4ef0EAN2NkKsBC3sgmelYBGsxE6xCQTiD7BMa6UE/4AINpYiYk4E0UIR/4KFvZ2QIpjmvBCLm9E5yXrneXvX+MIHszPz7Ts7Mzu7dIlCh30f8BmTnZANYhE7+I1/2MxLNoIVnOI+yNKYa5eoBxNYxdV/RGncoT9NXm2QEONEba0iX3DbIOdXUt6PI30tszjGQLjexWVG3xss409SV4ZiRsKPJgYwgyNUsIQ9zIe2CjawhnUMh/q/IaeOdKpboQ8HOMd4qCuhmtz3InbOeuJWqGAhiOK9t9Cb9DmMhVbW+CWqSXkFn561l/MSp5SeXV+HyF38VW3NIz/TxjzFcbdHYTmr41t3dRZ92Fa/ydq6q7OoqB0ideQ51S/SKfFQt8Tn+NgN8RjOPJ3ZmeJmPo+viQJG8a2ROC8e//GK+B7KUx0QT0dfQfsPjKbo2nv8zju58QDTqGmOs5OGqQAAAABJRU5ErkJggg==".getData()
        return UIImage(data: base64)
    }

    static  var apiRequestselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAABlUlEQVRIie3WvWsUQRgH4McY8wF+RVshwT9AEOMnWlna2ASbQIKKghYpLWxs7O0UC0E7QYgxhYjYiWJKQSGCaRIEES3EQi5qLGYXX4eFO+Lu2uQHA3M77+yzezezt/ynbGrZG8ZJHGwD240J3MNXrOFWU9hezOApVgsstlN1QX04gGt4UwHF9g1D+Qlm8KHLxCfSb1VmEp+6zPkS+rM5eqLL5NheYVsxb6A4WVXdCs5iORybhv4AHw/9B/lVVeQibqCDM7iP08XYKm7iKq5jT3H8Fx7n8GDo3+0BhkNYyPARXMJbjONyqH+Bjzm8nuzCYemr70jb5kcx1o/b2Bzq58tO3z/CpDs8ii0BJS3U/VntXJ0w7MCRAi8zntW8w2LdcMQHis9TeBjG52JxnXCOlwuuxB81CcP2CvwOXjYNl/gxaYt2cA4/24Bhq7TaB6sGm4QjPto2XOLPMdY2THpWP/Pnmf1XLuj932m97XwVvBNLDaLvpX2O9LJ3JeBD2Ce9J9WZz3iN7xFeqxnpKW0tro1spL38Bi+vmfis3ZEQAAAAAElFTkSuQmCC".getData()
        return UIImage(data: base64)
    }

    static  var apiResponseUnselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAAB+ElEQVRIid3XT4iNURjH8c9w63ZTlCgZ5U8aTSlJYubO+LNio1goC8nC2kY2rP1Z2FmN0oSlhcQKWWAuyUIW/lsow8QkG2LBWLzn7b6O9733zr29Kb86i/uc8zzf8+d9znMu/0hze/A9hHV43I3znB7AG7G5W+dewD2pkmObh4tYXuBzBSci23HsKRj/FgfwtR14HzbgZEGgZzm2O/hUMP5YiHm+HXgUN3GuIFCe7oaWp02ox+C8Mx7GxCyg7dQIMf9QDF6E1SWAB7C4FbiOabyO7LtR6wBSw87I9hyfMdQO3MBMZD+Nq23gtTDmTGSfwX3RdsfgEdzLCboNy1rAq7iMFdiR09+QLCpXVXwXbUlGS/AUNwJ8LLQqruMl+gt8t4bY1dTQl+kcwS0swI8W8Nt4hyn8knyQA9iOyQK/Gr6ECTyIO48qzsWs+iWr+xlaq5Vm9RBH0h/ZMy4631iT2IIXeKP1SrOakJPPffiIXR0ESDU/tE61Fx9i4xrN8ypLSyWptYrmVtcliT5dIvi9pFLVaRaJ4TCjRyWCYWFgXUrBa3FNZ191LxrFeporrgTobEphtxqk3KdPBRcwLqfulwleKXnyHJTc4X/Nqiy9wmFJmsZltlQwnC3qSMHfsF/yyCtTg8JrM/0n8URy0Zf9zp7CKTlX5/+v3w+zWpGe3p9eAAAAAElFTkSuQmCC".getData()
        return UIImage(data: base64)
    }

    static  var apiResponseSelectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAABf0lEQVRIie2WPS8EURSGHyLotqBYy24kWolCgyi2ki1UColityJR7K/gT/gDSBT+gFY2SHTKlSDCIiSq9VFQzBlz5vvDnYTwJjcz994z73POzZ25A39NPRmfqwArcr8LXJlJJ15V4ENaNYtBr9F0/sE/EdyXInYeGJT7KTU+rXxegEMDebm0AHRxdrO3vQKLpqFxcGPQJnAgreyZq3ngXRnTKqvnm0mhA8CdmB6FxNiVR1V6LB4POHsjUg2cauoRcTX8lWrVlU8jCfhEgu+TZhqifqAjXqdxwbM4WW58A2prU/nNRAXuSNA7MGYAXALexHNbT+hjsQhcYi3RBbBlAAywDoxLAhWsjevSGuEfB1Nt1Ybpb3XJUIVRGg0CZ/0bCdItsC9XrS9GmkMiDXQSeAKGgDOs/eNSHsdiS6AAj9L3KQ/wHFalAMPS9ymPpR7BWt6WQH3L7AXfGIQXgaWA8eug4ALQJr93uC0MwP8KFYBlYCJtiTE6B/aAZ8O+v0ifjsWDLFsV2RsAAAAASUVORK5CYII=".getData()
        return UIImage(data: base64)
    }

    static  var apiInfoUnselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAACfklEQVRIie3WS4iOYRQH8N9gjMuQBWEiZeGyEYNZjFBsXLIjxm1DLMZCoWQSErkUG4qlkFIuK8mCkhXKZSW3IZdGLuV+vyye8+ad6Zvxfaah5F9Pve9zznn+z3Pe/znPy3/86ygr0q8PJmI0hqM/KsP2Bk9wA9dwHi/bQ1yJOizEBLzCJdzEQ7wOv14YhGGoifcLOIwjsbGi0Bub8SIItqEanYqI7YSx2B6xz7EpNtMm6vAYt7EI5QV8yjEEo2IMacWvKxbjLh5hbiHCShzERzSgImfrLKV6K67iM763GJ9wBVtQGzEZKrA+fA6gZ2YYgMu4I4knf7KlaJTEcghLMA79wl4ez+PD93D43g3ffCaqY/5ScDolCaUq5zQ9nB5gGboXSlMr6I7l0je+g2k5W1VwnYLBcaqjUlq2SkpcXYCwStLBKuyKsQrzMLDABtbgrfQJKoKjMTjB0NhhE+5JaclQgRW4iG9hPyul/lA83w/bRdRLwspQHTFNwTG0ZYpG4Dj65ubqckHrMLJlUA4jw+dJnCqv4r44Fhxtohx7JZWvQ49fBeTQQ6qMT7FGoVJrFSckddbk5rpgjpTeW5IO3kid7CBma15GNbHGyVKIayX1NcT7LKmpNGEf5mNSjPnYH7ZbmBkxDbFGbSnEMAXvcMZPlXdrwz+v4jMRO6VU0gwzpFPkG0uZpNQFMao1v2zGRMyM3yXNkBfHAkmxX6Rr8EY8N0opLxTTbuyVlLpL85Lrh91h21PsYsVcdRmyBnIOz3LzT3EaX3G9hPVKQj0+SL08w1S8l1pnh2KlpNzJfpbd2o4mzbBRag4vseFPkWbYiR1/mpRUu8X+pf7H38MP072aGtc7R7EAAAAASUVORK5CYII=".getData()
        return UIImage(data: base64)
    }

    static var apiInfoselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAAB/ElEQVRIie3WvWsUQRjH8Y+YqPiCFuZAMIWVirFKkICC+C9IAmJnYyGIhYKFgtEEfGktgn+D2CkoaAQrES4KFiKWihBQSGKIBMJpMbNksrm93T0uXX7wsLtzM893Zp7nmTm2tKVN0rYKfbbjFM5hGMdwCHvj70v4ia9oYgYf0Op2UoN4gB/4V9O+4z4O1wEO4AlWugDmbQXTOFgGvYjfPQDm7RcutAP2x1X2Gpi3afSl0BclA1bxDtcxikYc1x/fR3Ej9lkt8fU8jgMTBZ2W8TA6r6oGHuFvgc+J/IA8/KmQ2ZmO4iZe44tQRstC1r/CHRxP+g/iWRk0hbdwy1qNj+BNwezb2YxQ96KP29FnITTTUHz24XEcVBX6FpdyK099lmpXzVV+w9mqzstUlHB5e48DcUwDU/go5MASZjGpXoJugH/GNZzAHuzGjth3HIsdJriIsbrwFVwRLox2GlctF1p14UficyeuCtv7MrY1dF5p3haE+6Cy9gmxyxxcju1TJaA54To9k7TdqwNmfcxPxrZPJdCslEaS9tm64BS+P36n23w6AuZy0KH4nSZaV5oQaj0PHk5ARdAszl0rO1LTuKerLIJ2vdV5TdoY1xFrW94u9nd7Aa5bTvMq/BWqqjHVD5DzvYKm8IUO0PnNgGYaEA6HJv5EawoxXbe9/wEg7FM5lpDfOAAAAABJRU5ErkJggg==".getData()
        return UIImage(data: base64)
    }

    static  var apiUnselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAABJ0lEQVRIie3VvUoDQRSG4SciWNhoqxAQrGxtLC1MZ+kPauMtaIqgN2KuQMFGLyCweAHaiBdgITaCKRQhFrHYWTPGn6yQDSj7wjDLd5b59szMOUtJyX+jEj3vYB2TBXk94xTHsbiN7ojGFowH480wP+JyuIm+s4jp4HWSiUn4mqQg008eYwUa/cifMF5FA1OR1ghjQ69CGqjmXTTPGd+Ed9YirSu9jE84iLTlQR55M57FQjCv9cXqOMNSzrXQK6dBrOAeTez3xRK8Src7N3kzrmECu5jDfBSrB+182MYVacYXaOHBx+2+wt1vTMm31TO4xh5u8aJ3s1vSbhfzlfYtZecqnOyMO2GuSjtPEWTdrBOLh0b3P846HNIabaJdoGEbR8GrpKQ43gCN8oRHGR7/6AAAAABJRU5ErkJggg==".getData()
        return UIImage(data: base64)
    }

    static var apiselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAABE0lEQVRIie3TMUoDURDG8Z+iiAgBwUYs7BWbXECEHEBBESQH8CRCimitlYWVWtpFCGLjCawEQdA6FhamicWu+FyMvsDuirIfDOz7Zpg/M8xSqdJ/01jw3cQmZgpiveAcJ6HZxKCk2IHxFLxVxIhDtB2CayWCayG4dP0J8AVa6AVeK41TyeG8ew+xTbt+vsaltPYs8KAu+QX3Au+7fl3iJ37ELZbRyeTa2MBNZC8wEVl3iXnsYj+TW8OkZN3Rip24g1cc4x53Qa6deut5gweSiVfRwJzP665jYRQocat+wgoOsIhpH5fdwGym/itvqGKuOq8Y6apz16+D+yUy+yH4ukTwVfiYwhGeFXdUPRymrEqVitMbCpqFEGsMmeIAAAAASUVORK5CYII=".getData()
        return UIImage(data: base64)
    }

    static var userDefaultselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAABhUlEQVRIie3XsU7cQBDG8V8gSn8d1yALCQRVCh4gROQdEDVvgJBoSRceInW6SKmjiKA0IJEWqABR0aWBAgS5FGvr9o61cbDvoOCTLK1nx/P3zFhze7xoTHpVYu9iHpMN49/hCBd1nDdwi15L1y3WH4J2W4bG8KkYNDEEntW8vClNYq4KPHzfpgZiv65w/I0/DWEdLNZxXNLvy1JDKLwvizfK0lbqycBVPS40jdV8/QXnQ7aUCr9eE/AMPuXr/TxgbEup8CubjM+71D/df/OU7b/0rDN+6OMqbCld1X2R1ACpa+vgQ351o5ibEgOkTsZ19Rbf8/W5MLVOsK3/i1eqJiMzfraHU2TR/pvYuc2P6xhn0X2GnQh+MyrwBd4J5Y3hu8LAGdBwj/9G68XEfpkusSf0dtlgptP4IfT8LPm0cDx57NFnM4qTCT2u6vk9rY8IfoeVYrNs7E1hwePOX79wHcF3hHKv4Rs+q3HqbEOZkGkHB0L2h+MAF/qqX/aP4wRnwr+KLfgHRweczQP6jvcAAAAASUVORK5CYII=".getData()
        return UIImage(data: base64)
    }

    static var userDefaultUnselectedImage: UIImage? {
        let base64 = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAAA+ElEQVRIie2WPQ6CMBSAP38u4CQcQKMTgydw8EASjsGNdPACDkxewY0DgOgAjU2ltIRCHPolJC+vj/eV5iUUPBMx0+RDYAcsBvZ/AQ/gaVOcACXwdvSUQGySho6lsjyQRUtFvOF7vAmQmXZqIALSpucW6chV8VyK78BtoLjU9P4RyxwM6zZEuoWuxulAaSdzc8k4dH2xy+HqJXY9XNZiwYp60MRmciXXhqjTYiOOgEsTH6lPQc61Ieq0/OVwCTLgJMVqTvfOYHEOXC1yvfDDNRl+uCopdv1brLRV1NeTMa4+BbA27TJ2LC+AsyrRXW8DYM/E11vPKHwA9gmHl4bj6ywAAAAASUVORK5CYII=".getData()
        return UIImage(data: base64)
    }

}

public extension URLSessionConfiguration {
    private static var isStartingForFirstTime = true

    static func implementNoober() {
        guard isStartingForFirstTime else { return }
        isStartingForFirstTime = false
        swizzleConfigProtocolSetter()
        swizzleConfigDefault()
        swizzleConfigEphemeral()
    }

    private static func swizzleConfigProtocolSetter() {
        let config = URLSessionConfiguration.default
        let configClass: AnyClass = object_getClass(config)!

        let defaultSetter = #selector(setter: URLSessionConfiguration.protocolClasses)
        let customSetter = #selector(setter: URLSessionConfiguration.protocolClasses_Swizzled)

        let defaultMethod = class_getInstanceMethod(configClass, defaultSetter)!
        let customMethod = class_getInstanceMethod(configClass, customSetter)!
        method_exchangeImplementations(defaultMethod, customMethod)

    }

    @objc private var protocolClasses_Swizzled: [AnyClass]? {
        get {
            return self.protocolClasses_Swizzled
        }
        set {
            guard let newTypes = newValue else {
                self.protocolClasses_Swizzled = nil
                return

            }

            var types = [AnyClass]()

            for newType in newTypes {
                if !types.contains(where: { $0 == newType }) {
                    types.append(newType)
                }
            }

            self.protocolClasses_Swizzled = types
        }
    }

    private static func swizzleConfigDefault() {
        let aClass: AnyClass = object_getClass(self)!

        let defaultSelector = #selector(getter: URLSessionConfiguration.default)
        let customSelector = #selector(getter: URLSessionConfiguration.default_swizzled)

        let defaultMethod = class_getClassMethod(aClass, defaultSelector)!
        let customMethod = class_getClassMethod(aClass, customSelector)!

        method_exchangeImplementations(defaultMethod, customMethod)
    }

    private static func swizzleConfigEphemeral() {
        let aClass: AnyClass = object_getClass(self)!

        let defaultSelector = #selector(getter: URLSessionConfiguration.ephemeral)
        let customSelector = #selector(getter: URLSessionConfiguration.ephemeral_swizzled)

        let defaultMethod = class_getClassMethod(aClass, defaultSelector)!
        let customMethod = class_getClassMethod(aClass, customSelector)!

        method_exchangeImplementations(defaultMethod, customMethod)
    }

    @objc private class var default_swizzled: URLSessionConfiguration {
        get {
            let config = URLSessionConfiguration.default_swizzled
            config.protocolClasses?.insert(NooberProtocol.self, at: 0)

            return config
        }
    }

    @objc private class var ephemeral_swizzled: URLSessionConfiguration {
        get {
            let config = URLSessionConfiguration.ephemeral_swizzled
            config.protocolClasses?.insert(NooberProtocol.self, at: 0)

            return config
        }
    }
}

extension UIWindow {
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if Noob.shared.shakeToOpen {
                NoobHelper.toogle()
            }
        }
    }
}
