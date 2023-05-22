//
//  LionFileDownLoader.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//

/**
 let downloader = LionFileDownloader(useBackgroundSession: true)
 let request = LionRequest(url: "https://example.com/file.pdf")
 
 downloader.download(request, to: { (temporaryURL, response) -> URL in
 let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
 let destinationURL = documentsURL.appendingPathComponent(response.suggestedFilename ?? "file.pdf")
 return destinationURL
 }, progressHandler: { progress in
 print("Download progress: \(progress)")
 }) { result in
 switch result {
 case .success(let destinationURL):
 print("Downloaded file to: \(destinationURL)")
 case .failure(let error):
 print("Download failed with error: \(error)")
 }
 }
 */

import Foundation

public class LionFileDownloader: LionDownloader {
    private let useBackgroundSession: Bool
    private let delegate: LionDownloaderDelegate
    
    private lazy var session: URLSession = {
        let configuration = useBackgroundSession ? URLSessionConfiguration.background(withIdentifier: "com.LionNetworking.LionFileDownloader.background") : URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }()
    
    public init(useBackgroundSession: Bool = false) {
        self.useBackgroundSession = useBackgroundSession
        self.delegate = LionDownloaderDelegate()
    }
    
    public func download(
        _ request: LionRequest,
        to destination: @escaping (URL, HTTPURLResponse) -> URL,
        progressHandler: ((Double) -> Void)? = nil,
        completion: @escaping (Result<URL, LionError>) -> Void) {
            let urlRequest = request.urlRequest
            let task = session.downloadTask(with: urlRequest)
            delegate.completionHandlers[task] = completion
            delegate.progressHandlers[task] = progressHandler
            delegate.destinationHandlers[task] = destination
            task.resume()
        }
}
