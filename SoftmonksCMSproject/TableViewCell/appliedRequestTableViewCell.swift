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
    
    func updateViews(leaveReuests: LeaveRequest){
        appliedOnDateLabel.text = leaveReuests.appliedOnDate
        fromDateLabel.text = leaveReuests.fromDate
        toDateLabel.text = leaveReuests.toDate
        NoOfDaysLabel.text = leaveReuests.noOfDays
        leaveTypeLabel.text = leaveReuests.leaveType
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
