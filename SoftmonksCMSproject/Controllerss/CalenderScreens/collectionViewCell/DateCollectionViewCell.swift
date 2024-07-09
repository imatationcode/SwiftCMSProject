//
//  DateCollectionViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 05/07/24.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateDigitLabel: UILabel!
    @IBOutlet weak var dateCellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    public func configureCell(dateString: String, isCurrentDateCell: Bool) {
        dateDigitLabel.text = dateString
        if isCurrentDateCell {
           dateCellBackgroundView.backgroundColor = .white
        } else {
            dateCellBackgroundView.backgroundColor = UIColor(hex: "E5E5E5")
        }
        
        dateCellBackgroundView.layer.cornerRadius = 2.5
        dateCellBackgroundView.layer.borderWidth = 0.5
        dateCellBackgroundView.layer.borderColor = UIColor.lightGray.cgColor

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DateCollectionViewCell", bundle: nil)
    }


}
