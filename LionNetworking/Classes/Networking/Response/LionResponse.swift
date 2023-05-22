//
//  LionResponse.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//

import Foundation

public struct LionResponse {
    public let urlResponse: URLResponse?
    public let data: Data?

    public init(urlResponse: URLResponse?, data: Data?) {
        self.urlResponse = urlResponse
        self.data = data
    }
}
