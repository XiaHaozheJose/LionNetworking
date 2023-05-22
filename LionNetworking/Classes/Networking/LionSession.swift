//
//  LionSession.swift
//  LionNetworking
//
//  Created by JSCoder on 18/3/23.
//

import Foundation

public class Lion {
    public static let shared = Lion()

    private let urlSession: URLSession

    private init() {
        self.urlSession = URLSession(configuration: .default)
    }

    public init(configuration: URLSessionConfiguration) {
        self.urlSession = URLSession(configuration: configuration)
    }

    public func execute<T: LionResponseDecoder>(
        request: LionRequest,
        requestEncoder: LionRequestEncoder = LionJSONRequestEncoder(),
        responseDecoder: T,
        authenticator: LionAuthenticator? = nil,
        interceptor: LionInterceptor? = nil,
        retryHandler: LionRetryHandler? = nil,
        retryCount: Int = 0,
        completion: @escaping (Result<T.ReturnType, LionError>) -> Void
    ) {
        // Authenticate request using authenticator if provided
        let authenticatedRequest: LionRequest
        do {
            authenticatedRequest = try authenticator?.authenticate(request: request) ?? request
        } catch {
            completion(.failure(LionError.authenticationFailed(error: error)))
            return
        }
        
        // Adapt request using interceptor if provided
        let adaptedRequest: LionRequest
        do {
            adaptedRequest = try interceptor?.adapt(request: authenticatedRequest) ?? request
        } catch {
            completion(.failure(LionError.requestAdaptationFailed(error: error)))
            return
        }
        
        // Encode the request using the provided encoder
        let urlRequest: URLRequest
        do {
            urlRequest = try requestEncoder.encode(adaptedRequest)
        } catch {
            completion(.failure(LionError.encodingFailed(error: error)))
            return
        }
        // 调用插件的 willSend 方法
        interceptor?.willSend(request: request)
        
        // Create URLSessionDataTask
        let task = urlSession.dataTask(with: urlRequest) {[weak self] data, response, error in
            if let error = error {
                let lionError = LionError.requestFailed(error: error)
                interceptor?.didReceive(error: lionError, forRequest: request)
                completion(.failure(lionError))
            } else {
                //If has data
                guard let data = data else {
                    completion(.failure(LionError.emptyData))
                    return
                }
                //
                let result = interceptor?.handle(response: response, data: data, error: error) ?? Result.success(data)
                let handledResult = result
                    .flatMapError { error in Result.failure(LionError.unknown(error: error)) }
                    .flatMap { data in
                        do {
                            interceptor?.didReceive(response: LionResponse(urlResponse: response, data: data), forRequest: request)
                            return .success(try responseDecoder.decode(data))
                        } catch {
                            let lionError = LionError.decodingError(error: error)
                            interceptor?.didReceive(error: lionError, forRequest: request)
                            return .failure(lionError)
                        }
                    }
                switch handledResult {
                case .success:
                    DispatchQueue.main.async {
                        completion(handledResult)
                    }
                case .failure(let error ):
                    retryHandler?.shouldRetry(request: request, error: error, retryCount: retryCount) { shouldRetry, timeDelay in
                        if shouldRetry {
                            DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
                                self?.execute(
                                    request: request, requestEncoder: requestEncoder, responseDecoder: responseDecoder,
                                    authenticator: authenticator, interceptor: interceptor, retryHandler: retryHandler,
                                    retryCount: retryCount + 1, completion: completion )
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                        } } }
            }  }
        task.resume()
    }
    
}
