//
//  PasswordResetCompletionVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 18/03/24.
//

import UIKit

class PasswordResetCompletionVC: UIViewController, LogoDisplayable {
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addLogoToFooter()
        mainImageView.mainIconImage.image = UIImage(named: "DoneSolidIcon")
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Password Reset Complete"
        navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func loginButtonTaped(_ sender: Any) {
        if let loginVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVc {navigationController?.pushViewController(loginVc, animated: true)}
        
    }

}
