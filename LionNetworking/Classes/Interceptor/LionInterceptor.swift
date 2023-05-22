//
//  LionInterceptor.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation

public protocol LionInterceptor {
    func adapt(request: LionRequest) throws -> LionRequest
    func handle(response: URLResponse?, data: Data?, error: Error?) -> Result<Data, Error>
    
    
    func willSend(request: LionRequest)
    func didReceive(response: LionResponse, forRequest request: LionRequest)
    func didReceive(error: LionError, forRequest request: LionRequest)
}

public extension LionInterceptor {
    func willSend(request: LionRequest) {}
    func didReceive(response: LionResponse, forRequest request: LionRequest) {}
    func didReceive(error: LionError, forRequest request: LionRequest) {}
    
    func adapt(request: LionRequest) throws -> LionRequest {
           return request
       }
    func handle(response: URLResponse?, data: Data?, error: Error?) -> Result<Data, Error> {
        return .success(data ?? Data())
    }
}
