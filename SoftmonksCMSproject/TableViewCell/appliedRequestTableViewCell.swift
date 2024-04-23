//
//  newTableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 06/03/24.
//

import UIKit

class appliedRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var appliedOnDateLabel: UILabel!
    @IBOutlet weak var NoOfDaysLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var inProgressView: UIView!
    
    func updateViews(leaveReuests: LeaveData){
        appliedOnDateLabel.text = leaveReuests.appliedDate
        fromDateLabel.text = leaveReuests.fromDate
        toDateLabel.text = leaveReuests.toDate
        NoOfDaysLabel.text = leaveReuests.noOfDays
        let leaveTypeMap: [String: String] = [
                "fd": "FULL DAY",
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
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        inProgressView.onlyCornerRadius(conRadius: 10.0)
        outterView.onlyCornerRadius(conRadius: 8.0)
        addElevatedShadow(to: outterView)
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
