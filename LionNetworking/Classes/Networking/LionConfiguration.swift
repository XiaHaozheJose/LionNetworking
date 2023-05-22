//
//  LionConfiguration.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation
public struct LionConfiguration {
    public let timeoutInterval: TimeInterval

    public init(timeoutInterval: TimeInterval = 30.0) {
        self.timeoutInterval = timeoutInterval
    }
}
