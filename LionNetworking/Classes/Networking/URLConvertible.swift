//
//  URLConvertible.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation

public protocol URLConvertible {
    func asURL() throws -> URL
}

extension URL: URLConvertible {
    public func asURL() throws -> URL {
        return self
    }
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        if let url = URL(string: self) {
            return url
        } else {
            throw LionError.invalidURL(url: self)
        }
    }
}
