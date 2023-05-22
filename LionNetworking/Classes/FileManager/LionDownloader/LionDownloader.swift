//
//  LionDownloader.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//

import Foundation

public protocol LionDownloader {
    func download(_ request: LionRequest,
                  to destination: @escaping (URL, HTTPURLResponse) -> URL,
                  progressHandler: LionProgressHandler?,
                  completion: @escaping (Result<URL, LionError>) -> Void
    )
}
