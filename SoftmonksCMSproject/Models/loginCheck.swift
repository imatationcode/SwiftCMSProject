//
//  loginCheck.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 08/04/24.
//

import Foundation

struct loginCheck: Codable {
    let err: Int
    let key, errMsg, userId, name, designation: String
}
