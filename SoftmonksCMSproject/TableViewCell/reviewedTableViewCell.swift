//
//  reviewedTableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 07/03/24.
//

import UIKit

class reviewedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var appliedOnDateLabel: UILabel!
    @IBOutlet weak var NoOfDaysLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var rejectedButton: UIButton!
    @IBOutlet weak var approvedButton: UIButton!
    
    func updateViews(leaveReuests: LeaveData){
        appliedOnDateLabel.text = leaveReuests.appliedDate
        fromDateLabel.text = leaveReuests.fromDate
        toDateLabel.text = leaveReuests.toDate
        NoOfDaysLabel.text = leaveReuests.noOfDays
        let leaveTypeMap: [String: String] = [
                "fd": "Full Day",
                "mhd": "Morning Half Day",
                "ehd": "Evening Half Day"
                // Add more mappings as needed
            ]
            
            // Set leaveTypeLabel text based on the mapping
        if let leaveTypeText = leaveTypeMap[leaveReuests.leaveType ?? ""] {
                leaveTypeLabel.text = leaveTypeText
            } else {
                leaveTypeLabel.text = leaveReuests.leaveType
            }
        if leaveReuests.rejected == 1 {
            approvedButton.isHidden = true
            rejectedButton.isHidden = false
        } else {
            rejectedButton.isHidden = true
            approvedButton.isHidden = false
        }
    }

    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        outterView.onlyCornerRadius(conRadius: 8.0)
        addElevatedShadow(to: outterView)
        
    }

   
    
}
