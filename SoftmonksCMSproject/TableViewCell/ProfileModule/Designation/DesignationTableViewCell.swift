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
    @IBOutlet weak var fromDatelabel: UILabel!
    @IBOutlet weak var todatelabel: UILabel!
    @IBOutlet weak var curentRoleIndicatorView: UIView!
    @IBOutlet weak var designationTitle: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var toTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustFontSizeForDevice(textFields: [], labels: [designationTitle, designationValueLabel, dateTitleLabel, fromDatelabel, todatelabel, toTextLabel])
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
        self.fromDatelabel.text = roledata.startDate
        self.todatelabel.text = roledata.endDate
        if roledata.isCurrentDesignation == 1 {
            curentRoleIndicatorView.isHidden = false
        }
    }
    
}
