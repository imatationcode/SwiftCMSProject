//
//  TableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 04/03/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var appliedOnDateLabel: UILabel!
    @IBOutlet weak var NoOfDaysLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var inProgressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inProgressView.onlyCornerRadius(conRadius: 5)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
