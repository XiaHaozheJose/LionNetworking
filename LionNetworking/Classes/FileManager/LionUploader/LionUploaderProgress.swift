//
//  LionUploaderProgress.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//

import Foundation

class LionUploaderDelegate: NSObject, URLSessionTaskDelegate {
    
    var progressHandler: LionProgressHandler?

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        if let progressHandler = progressHandler {
            let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
            DispatchQueue.main.async {
                progressHandler(progress)
            }
        }
    }
}
