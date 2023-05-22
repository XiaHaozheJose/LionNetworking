//
//  LionUploader.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//

import Foundation

public protocol LionUploader {
    func upload<T: LionResponseDecoder>(
        request: LionRequest,
        files: [LionUploadableFile],
        requestEncoder: LionRequestEncoder,
        responseDecoder: T,
        authenticator: LionAuthenticator?,
        interceptor: LionInterceptor?,
        retryHandler: LionRetryHandler?,
        retryCount: Int,
        useBackgroundSession: Bool,
        progressHandler: ((Double) -> Void)?,
        completion: @escaping (Result<T.ReturnType, LionError>) -> Void
    )
}

public class LionFileUploader: LionUploader {
    private let useBackgroundSession: Bool
    private let delegate: LionUploaderDelegate
    
      private lazy var session: URLSession = {
          let configuration = useBackgroundSession ? URLSessionConfiguration.background(withIdentifier: "com.LionNetworking.LionFileUploader.background") : URLSessionConfiguration.default
          return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
      }()

      public init(useBackgroundSession: Bool = false) {
          self.useBackgroundSession = useBackgroundSession
          self.delegate = LionUploaderDelegate()
      }

    public func upload<T: LionResponseDecoder>(
        request: LionRequest,
        files: [LionUploadableFile],
        requestEncoder: LionRequestEncoder = LionJSONRequestEncoder(),
        responseDecoder: T,
        authenticator: LionAuthenticator? = nil,
        interceptor: LionInterceptor? = nil,
        retryHandler: LionRetryHandler? = nil,
        retryCount: Int = 0,
        useBackgroundSession: Bool = false,
        progressHandler: ((Double) -> Void)? = nil,
        completion: @escaping (Result<T.ReturnType, LionError>) -> Void
    ) {
        delegate.progressHandler = progressHandler
        do {
            let urlRequest = try requestEncoder.encode(request)
            let boundary = "Boundary-\(UUID().uuidString)"
            var requestWithContentType = urlRequest
            requestWithContentType.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let httpBody = createHttpBody(with: files, boundary: boundary)
            requestWithContentType.httpBody = httpBody
            let task = session.uploadTask(with: requestWithContentType, from: httpBody) { data, urlResponse, error in
                if let error = error {
                    completion(.failure(LionError.invalidUploadRequest(error: error)))
                    return
                }
                
                guard let _ = urlResponse as? HTTPURLResponse else {
                    completion(.failure(LionError.invalidResponse(url: urlRequest.url!)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(LionError.invalidResponse(url: urlRequest.url!)))
                    return
                }
                
                do {
                    let decodedResponse = try responseDecoder.decode(data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(LionError.decodingError(error: error)))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(LionError.encodingFailed(error: error)))
        }
    }
    
    private func createHttpBody(with files: [LionUploadableFile], boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        for file in files {
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(file.fileName)\"; filename=\"\(file.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(file.mimeType)\(lineBreak)\(lineBreak)")
            body.append(file.data)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)} }
}
