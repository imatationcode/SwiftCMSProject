//
//  DesignationVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit

class DesignationVC: UIViewController {
    let blueColor = UIColor(hex: "00369A")
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageView.mainIconImage.image = UIImage(named: "ColoreDestinationFlag")
        
        

    }



}
