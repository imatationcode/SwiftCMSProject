//
//  uploadDocument.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 27/06/24.
//

import Foundation
struct MandatoryDocument: Codable {
    let key: String?
    let value: String?
}

// Define the structure for the overall response
struct RequiredDocResponse: Codable {
    let err: Int?
    let successMsg: String?
    let derivedClass: Int?
    let mandatoryDocuments: [MandatoryDocument]
}

struct AddFileResponse: Codable {
    let err: Int?
    let errMsg: String?
    let slot: String?
    let mediaId: Int?
    let SuccessMsg: String?
    let fileName: String?
    let fileSize: String?
}
