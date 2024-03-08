//
//  CollectionViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/02/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var optionTitle: UILabel!
    @IBOutlet weak var optionImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.addGradientBackground(firstColor: (UIColor(red: 5.0/255,green: 61.0/255,blue: 161.0/255, alpha: 1.0)),
                                    secondColor: (UIColor(red: 56.0/255,green: 145.0/255,blue: 234.0/255,alpha: 1.0)),
                                       angle: -135.0,conRads: 0.2)
            }
       // mainview.applyGradient(colors: ["00359A","41A0F7"],angle: -135.0,conRads: 0.06)
            
        
            
    }
}


