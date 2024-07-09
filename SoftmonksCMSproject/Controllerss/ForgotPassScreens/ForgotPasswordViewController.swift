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
        guard let mailID = mailID else {
            self.showAlert(title: "Error", message: "Mail ID is nil")
            return
        }
        
        let parameters: [String: Any] = ["mode": "verifyUsername", "username": mailID]
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .response { response in
                self.loaderActivityIncicatior.stopAnimating()
                
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data, !data.isEmpty else {
                            // Handle the empty response as success
                            if let verificationVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verificationViewController") as? VerificationViewController {
                                verificationVc.eMailId = self.mailID
                                self.navigationController?.pushViewController(verificationVc, animated: true)
                            }
                            return
                        }
                        
                        if let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(responseJSON)
                            
                            if let errMsg = responseJSON["errMsg"] as? String, !errMsg.isEmpty {
                                let errTitle = responseJSON["errTitle"] as? String ?? "Error"
                                self.showAlert(title: errTitle, message: errMsg)
                            } else {
                                if let verificationVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verificationViewController") as? VerificationViewController {
                                    verificationVc.eMailId = self.mailID
                                    self.navigationController?.pushViewController(verificationVc, animated: true)
                                }
                            }
                        } else {
                            self.showAlert(title: "Error", message: "Invalid response format")
                        }
                    } catch {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
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

