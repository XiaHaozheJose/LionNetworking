//
//  LionUploaderFile.swift
//  LionNetworking
//
//  Created by JSCoder on 19/3/23.
//
/**
 let jpegFile = LionUploadableFile(data: imageData, fileName: "image.jpeg", mimeType: LionDefaultMimeType.jpeg)

 // Custom MIME type
 struct CustomMimeType: LionMimeType {
     let rawValue: String
 }

 let customFile = LionUploadableFile(data: customData, fileName: "custom.file", mimeType: CustomMimeType(rawValue: "application/custom"))
 */
import Foundation

public protocol LionMimeType {
    var rawValue: String { get }
}

public struct LionUploadableFile {
    let data: Data
    let fileName: String
    let mimeType: LionMimeType

    public init(data: Data, fileName: String, mimeType: LionMimeType) {
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

public enum LionDefaultMimeType: String, LionMimeType {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case json = "application/json"
    case xml = "application/xml"
    case pdf = "application/pdf"
    case text = "text/plain"

}
