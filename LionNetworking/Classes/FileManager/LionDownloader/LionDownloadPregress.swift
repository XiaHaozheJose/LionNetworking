//
//  LionDownloadPregress.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//

import Foundation

class LionDownloaderDelegate: NSObject, URLSessionDownloadDelegate {
    var progressHandlers: [URLSessionDownloadTask: (Double) -> Void] = [:]
    var completionHandlers: [URLSessionDownloadTask: (Result<URL, LionError>) -> Void] = [:]
    var destinationHandlers: [URLSessionDownloadTask: (URL, HTTPURLResponse) -> URL] = [:]

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let httpResponse = downloadTask.response as? HTTPURLResponse else {
            completionHandlers[downloadTask]?(.failure(LionError.invalidResponse(url: location)))
            return
        }

        let destinationURL = destinationHandlers[downloadTask]?(location, httpResponse) ?? location
        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            completionHandlers[downloadTask]?(.success(destinationURL))
        } catch {
            completionHandlers[downloadTask]?(.failure(LionError.fileSaveFailed(error: error)))
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let downloadTask = task as? URLSessionDownloadTask,
           let completionHandler = completionHandlers[downloadTask] {
            if let error = error {
                completionHandler(.failure(LionError.requestFailed(error: error)))
            }
            progressHandlers[downloadTask] = nil
            completionHandlers[downloadTask] = nil
            destinationHandlers[downloadTask] = nil
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let progressHandler = progressHandlers[downloadTask] {
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            DispatchQueue.main.async {
                progressHandler(progress)
            }
        }
    }
}

