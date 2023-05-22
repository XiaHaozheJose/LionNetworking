//
//  LionError.swift
//  LionNetworking

/**
 public struct TimeoutError: LionErrorConvertible {
 public var asLionError: LionError {
 return .custom(error: self)
 }
 
 public var errorDescription: String? {
 return "Request timeout"
 }
 }
 */

//  Created by JSCoder on 18/3/23.
//

import Foundation
public protocol LionErrorConvertible: LocalizedError {
    var asLionError: LionError { get }
}

public enum LionError: LionErrorConvertible {
    case requestAdaptationFailed(error: Error)
    case invalidUploadRequest(error: Error)
    case requestFailed(error: Error)
    case invalidResponse(url: URL)
    case encodingFailed(error: Error)
    case decodingError(error: Error)
    case invalidURL(url: String = "")
    case authenticationFailed(error: Error)
    case fileSaveFailed(error: Error)
    case serverError(statusCode: Int, data: Data?)
    case unknown(error: Error)
    case emptyData
    case custom(error: LionErrorConvertible)
    
    public var asLionError: LionError {
        return self
    }
    
    public var errorDescription: String? {
        switch self {
        case .fileSaveFailed(let error):
            return "File sabe failed \(error.localizedDescription)"
        case .requestAdaptationFailed(let error):
            return "Request adaptation failed: \(error.localizedDescription)"
        case .requestFailed(let error):
            return "Request failed \(error.localizedDescription)"
        case .invalidUploadRequest:
            return "Upload request failed"
        case .invalidResponse(let url):
            return "Response invalid: \(url)"
        case .encodingFailed(let error):
            return "Encoding failed: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .authenticationFailed(let error):
            return "Authentication Failed \(error.localizedDescription)"
        case .serverError(let statusCode, _):
            return "Server error with status code: \(statusCode)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        case .emptyData:
            return "Received empty data from the server."
        case .custom(let error):
            return error.errorDescription
        }
    }
}
