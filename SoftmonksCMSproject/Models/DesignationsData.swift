//
//  DesignationsData.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 23/05/24.
//

import Foundation

struct DesignationsData: Codable {
    let err: Int?
    let errMsg: String?
    let derivedClass: Int?
    let userDesignationData: [RoleData]?
}

struct RoleData: Codable {
    let designationType: String?
    let startDate: String?
    let endDate: String?
    let isCurrentDesignation: Int?
}

struct passResponse: Codable {
    let id: Int?
    let err: Int?
    let errMsg: String?
    let derivedClass: Int?
}
