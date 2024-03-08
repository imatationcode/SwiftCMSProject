//
//  DataService.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 05/03/24.
//

import Foundation
class DataService{
    static let instance = DataService()
    
    private let leaveRequestsArray = [
        LeaveRequest(appliedOnDate: "02/10/23", noOfDays: "03", fromDate: "01/01/2024", toDate: "10/01/2024", leaveType: "Full Day"),
        LeaveRequest(appliedOnDate: "02/10/23", noOfDays: "09", fromDate: "01/01/2024", toDate: "10/01/2024", leaveType: "Morniing"),
        LeaveRequest(appliedOnDate: "02/10/23", noOfDays: "09", fromDate: "01/01/2024", toDate: "10/01/2024", leaveType: "Afternoon"),
        LeaveRequest(appliedOnDate: "02/10/23", noOfDays: "09", fromDate: "01/01/2024", toDate: "10/01/2024", leaveType: "Evening"),
        LeaveRequest(appliedOnDate: "02/10/23", noOfDays: "09", fromDate: "01/01/2024", toDate: "10/01/2024", leaveType: "GoodNight"),
        LeaveRequest(appliedOnDate: "02/10/23", noOfDays: "03", fromDate: "01/01/2024", toDate: "10/01/2024", leaveType: "Full Day")
        
    ]
    
    func getLeaveRequests() -> [LeaveRequest]{
        return leaveRequestsArray
        
    }
}
