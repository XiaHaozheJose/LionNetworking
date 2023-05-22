//
//  LionUploadSession.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//

import Foundation

extension Lion {
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
          let uploader = LionFileUploader()
          uploader.upload(
              request: request,
              files: files,
              requestEncoder: requestEncoder,
              responseDecoder: responseDecoder,
              authenticator: authenticator,
              interceptor: interceptor,
              retryHandler: retryHandler,
              retryCount: retryCount,
              useBackgroundSession: useBackgroundSession,
              progressHandler: progressHandler,
              completion: completion
          )
      }
}
