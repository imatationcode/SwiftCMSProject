//
//  CompanyPoliciesTableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 12/06/24.
//

import UIKit

class CompanyPoliciesTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var PolicinameLabel: UILabel!
    @IBOutlet weak var uploadedTextLabel: UILabel!
    @IBOutlet weak var uploadedDateValueLabel: UILabel!
    @IBOutlet weak var ViewButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldView.layer.borderWidth = 0.5
        fieldView.layer.borderColor = UIColor.gray.cgColor
        adjustFontSizeForDevice(textFields: [], labels: [PolicinameLabel, uploadedTextLabel, uploadedDateValueLabel])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func tappedOnViewDocument(_ sender: Any) {
        print("Viewing doc")
    }

    
    func configureValues(document: UsuserDocuments) {
        PolicinameLabel.text = document.fileLabel
        uploadedDateValueLabel.text = document.uploadDate
    }
}
