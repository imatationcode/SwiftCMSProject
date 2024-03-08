//
//  LeaveRequestCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 05/03/24.
//

import Foundation

struct LeaveRequest {
    private(set) public var appliedOnDate: String
    private(set) public var noOfDays: String
    private(set) public var toDate: String
    private(set) public var fromDate: String
    private(set) public var leaveType: String
//    private(set) public var apporved: Bool
//    private(set) public var inProcess: Bool
    
    init (appliedOnDate: String,noOfDays: String, fromDate: String, toDate: String, leaveType: String){
        self.appliedOnDate = appliedOnDate
        self.noOfDays = noOfDays
        self.toDate = toDate
        self.fromDate = fromDate
        self.leaveType = leaveType
    }
    
}
