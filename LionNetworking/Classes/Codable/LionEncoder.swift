//
//  LionEncoder.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation

public protocol LionRequestEncoder {
    func encode(_ request: LionRequest) throws -> URLRequest
}

public class LionJSONRequestEncoder: LionRequestEncoder {
    public init() {}

    public func encode(_ request: LionRequest) throws -> URLRequest {
        guard let url = try? request.url.asURL() else {
            throw LionError.invalidURL()
        }

        var urlRequest = URLRequest(url: url, cachePolicy: request.cachePolicy, timeoutInterval: request.configuration.timeoutInterval)
        urlRequest.httpMethod = request.method.rawValue

        // Set headers
        request.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        // Encode parameters
        if let parameters = request.parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = data
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw LionError.encodingFailed(error: error)
            }
        }

        return urlRequest
    }
}

