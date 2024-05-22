//
//  personalDetailsTableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 22/05/24.
//

import UIKit

class PersonalDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var propertiLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configValues(with userDetail: UserDetail){
        propertiLabel.text = userDetail.key
        valueLabel.text = userDetail.value
    }
    
}
