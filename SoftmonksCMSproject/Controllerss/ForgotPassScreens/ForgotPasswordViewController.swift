//
//  ForgotPasswordViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 14/03/24.
//

import UIKit
import Alamofire



class ForgotPasswordViewController: UIViewController, LogoDisplayable {
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var mailID: String?
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var instructionMessageLabel: UILabel!
    @IBOutlet weak var loaderActivityIncicatior: UIActivityIndicatorView!
    @IBOutlet weak var alreadyLoggedINMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var outerScrollView: UIScrollView!
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFontSizeForDevice(textFields: [emailTextField,], labels: [emailLabel, instructionMessageLabel, alreadyLoggedINMessageLabel])
        loaderActivityIncicatior.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Recover Password"
        addLogoToFooter()
        mainImageView.mainIconImage.image = UIImage(named: "LockRecoverIcon")
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.outerScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        outerScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        outerScrollView.contentInset = contentInset
    }
    
    @IBAction func mailsendButtonTapped(_ sender: Any) {
        loaderActivityIncicatior.startAnimating()
        guard let mailAdd = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if mailAdd.isEmpty {
            loaderActivityIncicatior.stopAnimating()
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        } else {
            if (isEmailValid(mailAdd)) {
                print("Entered mail = \(mailAdd)")
                mailID = mailAdd
                otpAPICall ()
            }
        }
    }
        
    func otpAPICall() {
        let parameters: [String : Any] = ["mode": "verifyUser" , "username": mailID! ]
        passAPICall(parameters) { (success, errorMessage, uiqId) in
            if success {
                self.loaderActivityIncicatior.stopAnimating()
                if let varificationVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verificationViewController") as?
                    verificationViewController { varificationVc.eMailId = self.mailID; varificationVc.empID = uiqId; self.navigationController?.pushViewController(varificationVc, animated: true)}
            } else {
                self.loaderActivityIncicatior.stopAnimating()
                self.showAlert(title: "Invalid Mail", message: errorMessage ?? "")
                return
            }
        }
    }
            
    @IBAction func loginButtonTaped(_ sender: Any) {
        if let loginVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVc {navigationController?.pushViewController(loginVc, animated: true)}
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when return key is tapped
        textField.resignFirstResponder()
        return true
    }
    
}//END of Class

