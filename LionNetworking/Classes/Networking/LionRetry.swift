//
//  LionRetry.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation

public protocol LionRetryHandler {
    func shouldRetry(
        request: LionRequest,
        error: LionError,
        retryCount: Int,
        completion: @escaping (_ shouldRetry: Bool, _ timeDelay: TimeInterval) -> Void
    )
}

public class SimpleRetryHandler: LionRetryHandler {
    private let maxRetries: Int
    private let timeDelay: TimeInterval

    public init(maxRetries: Int = 3, timeDelay: TimeInterval = 1.0) {
        self.maxRetries = maxRetries
        self.timeDelay = timeDelay
    }

    public func shouldRetry(
        request: LionRequest,
        error: LionError,
        retryCount: Int,
        completion: @escaping (_ shouldRetry: Bool, _ timeDelay: TimeInterval) -> Void
    ) {
        completion(retryCount < maxRetries, timeDelay)
    }
}

public class ExponentialBackoffRetryHandler: LionRetryHandler {
    private let maxRetries: Int
    private let initialDelay: TimeInterval
    private let maximumDelay: TimeInterval

    public init(maxRetries: Int = 5, initialDelay: TimeInterval = 1.0, maximumDelay: TimeInterval = 32.0) {
        self.maxRetries = maxRetries
        self.initialDelay = initialDelay
        self.maximumDelay = maximumDelay
    }

    public func shouldRetry(
        request: LionRequest,
        error: LionError,
        retryCount: Int,
        completion: @escaping (_ shouldRetry: Bool, _ timeDelay: TimeInterval) -> Void
    ) {
        guard retryCount < maxRetries else {
            completion(false, 0)
            return
        }

        let delay = min(initialDelay * pow(2.0, Double(retryCount)), maximumDelay)
        completion(true, delay)
    }
}
