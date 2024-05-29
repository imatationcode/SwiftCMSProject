//
//  DesignationTableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 23/05/24.
//

import UIKit

class DesignationTableViewCell: UITableViewCell {
    let imgSelectedColor = UIColor(hex: "00369A")

    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var designationValueLabel: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var curentRoleIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetUp()
    }
    
    func initialSetUp() {
        outterView.onlyCornerRadius(conRadius: 10.0)
        addElevatedShadow(to: outterView)
        curentRoleIndicatorView.layer.cornerRadius = curentRoleIndicatorView.frame.size.height / 2
        curentRoleIndicatorView.layer.backgroundColor = imgSelectedColor?.cgColor
        curentRoleIndicatorView.isHidden = true
        
    }
    
    func configData(with roledata: RoleData) {
        self.designationValueLabel.text = roledata.designationType
        self.fromDate.text = roledata.startDate
        self.todate.text = roledata.endDate
        if roledata.isCurrentDesignation == 1 {
            curentRoleIndicatorView.isHidden = false
        }
    }
    
}
