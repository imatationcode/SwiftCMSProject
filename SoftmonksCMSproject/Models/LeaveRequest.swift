//
//  LeaveRequestCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 05/03/24.
//

import Foundation

struct LeaveResponse: Codable {
    let leaveTotal: String?
    let leaveTaken: String?
    let leaveAvailable: String?
    let leaveListData: [LeaveData]
}

struct LeaveData: Codable {
    let userId: Int?
    let recordId: Int?
    let leaveType: String?
    let day: String?
    let fromDate: String?
    let toDate: String?
    let appliedDate: String?
    let noOfDays: String?
    let reason: String?
    let approved: Int?
    let rejected: Int?
    let inProcess: Int?
}

struct DeleteAPIResponse: Codable {
    let err: Int
    let errMsg: String
    let derivedClass: Int?
}

