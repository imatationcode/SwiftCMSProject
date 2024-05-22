//
//  DocumentsVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit

class DocumentsVC: UIViewController {
    @IBOutlet weak var mainProfileImageView: ProfileImageCustomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainProfileImageView.mainIconImage.image = UIImage(named: "ColordescriptionIcon")

        // Do any additional setup after loading the view.
    }

}
