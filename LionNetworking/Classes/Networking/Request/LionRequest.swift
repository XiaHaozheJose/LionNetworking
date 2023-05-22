//
//  LionRequest.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case connect = "CONNECT"
    case trace = "TRACE"
}
public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

public class LionRequest {
    public var method: HTTPMethod
    public var url: URLConvertible
    public var headers: HTTPHeaders
    public var parameters: Parameters?
    public var uploadData: Data?
    public var configuration: LionConfiguration
    public var cachePolicy: URLRequest.CachePolicy
    
    public init(
        method: HTTPMethod = .get,
        url: URLConvertible,
        headers: HTTPHeaders = [:],
        parameters: Parameters? = nil,
        configuration: LionConfiguration = LionConfiguration(timeoutInterval: 30),
        uploadData: Data? = nil,
        cachePolocy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    ) {
        self.method = method
        self.url = url
        self.headers = headers
        self.parameters = parameters
        self.configuration = configuration
        self.uploadData = uploadData
        self.cachePolicy = cachePolocy
    }
}

public extension LionRequest {
    
    var urlRequest: URLRequest {
        guard let url = try? url.asURL() else {
            fatalError("Invalid URL: \(url)")
        }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: configuration.timeoutInterval)
        request.httpMethod = method.rawValue

        // Set headers
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Set parameters
        if let parameters = parameters {
            switch method {
            case .get, .head, .delete:
                // Add query parameters to URL
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
                components.queryItems = (components.queryItems ?? []) + queryItems
                request.url = components.url

            case .post, .put, .patch:
                // Add form parameters to HTTP body
                let body = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                request.httpBody = body.data(using: .utf8)

            default:
                break
            }
        }

        return request
    }
}
