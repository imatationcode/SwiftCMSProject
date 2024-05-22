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
    let errMsg: String?
    let derivedClass: Int?
    let userData: [UserDetail]
}

// Model for Individual User Detail
struct UserDetail: Codable {
    let key: String
    let value: String
}
