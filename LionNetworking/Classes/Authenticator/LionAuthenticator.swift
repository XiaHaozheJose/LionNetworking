//
//  LionAuthenticator.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation

public protocol LionAuthenticator {
    func authenticate(request: LionRequest) throws -> LionRequest
}

public class OAuth2Authenticator: LionAuthenticator {
    private let accessToken: String

    public init(accessToken: String) {
        self.accessToken = accessToken
    }

    public func authenticate(request: LionRequest) throws -> LionRequest {
        let authenticatedRequest = request
        authenticatedRequest.headers["Authorization"] = "Bearer \(accessToken)"
        return authenticatedRequest
    }
}

public class JWTAuthenticator: LionAuthenticator {
    private let jwtToken: String

    public init(jwtToken: String) {
        self.jwtToken = jwtToken
    }

    public func authenticate(request: LionRequest) throws -> LionRequest {
        let authenticatedRequest = request
        authenticatedRequest.headers["Authorization"] = "Bearer \(jwtToken)"
        return authenticatedRequest
    }
}
