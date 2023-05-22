//
//  LionDecoder.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation

public protocol LionResponseDecoder {
    associatedtype ReturnType
    func decode(_ data: Data) throws -> ReturnType
}

public class LionJSONResponseDecoder<T: Decodable>: LionResponseDecoder {
    public typealias ReturnType = T

    public init() {}

    public func decode(_ data: Data) throws -> ReturnType {
        let decoder = JSONDecoder()
        return try decoder.decode(ReturnType.self, from: data)
    }
}
