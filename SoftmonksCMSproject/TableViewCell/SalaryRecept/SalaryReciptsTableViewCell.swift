//
//  SalaryReciptsTableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 30/05/24.
//

import UIKit

class SalaryReciptsTableViewCell: UITableViewCell {

    @IBOutlet weak var issuedDateValueLabel: UILabel!
    @IBOutlet weak var issuedDateTextLabel: UILabel!
    @IBOutlet weak var ReceptTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustFontSizeForDevice(textFields: [], labels: [issuedDateTextLabel, issuedDateValueLabel, ReceptTitleLabel])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
