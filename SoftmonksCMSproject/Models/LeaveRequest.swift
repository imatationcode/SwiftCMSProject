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
    let recordId: String?
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
    let derivedClass: Int
}

//struct LeaveRequest {
//    private(set) public var appliedOnDate: String
//    private(set) public var noOfDays: String
//    private(set) public var toDate: String
//    private(set) public var fromDate: String
//    private(set) public var leaveType: String
////    private(set) public var apporved: Bool
////    private(set) public var inProcess: Bool
//
//    init (appliedOnDate: String,noOfDays: String, fromDate: String, toDate: String, leaveType: String){
//        self.appliedOnDate = appliedOnDate
//        self.noOfDays = noOfDays
//        self.toDate = toDate
//        self.fromDate = fromDate
//        self.leaveType = leaveType
//    }
//
//}
