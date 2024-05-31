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
//    @IBOutlet weak var approvedButton: UIButton!
    
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        outterView.onlyCornerRadius(conRadius: 8.0)
        addElevatedShadow(to: outterView)
        
    }
    
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
            rejectedButton.backgroundColor = UIColor.init(red: 255/255, green: 32/255, blue: 12/255, alpha: 1)
            rejectedButton.setTitle("Rejected", for: .normal)

        } else {
            rejectedButton.backgroundColor = UIColor.init(red: 0/255, green: 111/255, blue: 4/255, alpha: 1)
            rejectedButton.setTitle("Approved", for: .normal)
//            approvedButton.isHidden = false
        }
    }



   
    
}