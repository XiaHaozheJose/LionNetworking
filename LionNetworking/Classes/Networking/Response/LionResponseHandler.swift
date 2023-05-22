//
//  LionResponseHandler.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//
import Foundation

public protocol LionResponseHandler {
    associatedtype ReturnType
    func handle(response: Data?, error: Error?) -> Result<ReturnType, LionError>
}
