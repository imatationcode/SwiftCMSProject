//
//  BlueBorderForDetailsView.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 19/02/24.
//

import UIKit

class DesingsForUIView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        applyCustomBorderStyle()
    }
//blueBorder 
    func applyCustomBorderStyle() {
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 0.58, green: 0.80, blue: 1, alpha: 1).cgColor
        layer.cornerRadius = 10
    }

}
