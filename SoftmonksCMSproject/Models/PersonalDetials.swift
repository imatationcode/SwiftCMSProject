//
//  personalData.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 22/05/24.
//

import Foundation
struct PersonalDetialsResponse: Codable {
    let profilePhoto: String?
    let staffCode: String?
    let err: Int?
    let successMsg: String?
    let errMsg: String?
    let derivedClass: Int?
    let userData: [UserBasicInformation]?
    let Documents: [UsuserDocuments]?
}

// Model for Individual User Detail
struct UserBasicInformation: Codable {
    let key: String?
    let value: String?
}

struct UsuserDocuments: Codable {
    let filename: String?
    let uploadDate: String?
    let imagePath: String?
    let fileType: String?
    let fileLabel: String?
}
