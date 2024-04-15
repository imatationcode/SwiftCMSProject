//
//  ForgotPasswordViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 14/03/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController, LogoDisplayable {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var outerScrollView: UIScrollView!
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let mailAdd = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if mailAdd.isEmpty {
          showAlert(title: "Missing Email", message: "Please enter your email address.")
          return
        }
       

        
      func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let attributedTitle = NSAttributedString(string: title, attributes: [
                .foregroundColor : UIColor.red
              ])
              alertController.setValue(attributedTitle, forKey: "attributedTitle")
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
          }
        if (isEmailValid(mailAdd)) {
            LogManager.shared.setLoggedIn(true)
            print(LogManager.shared.isLoggedIn)
            if let varificationVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verificationViewController") as? verificationViewController {navigationController?.pushViewController(varificationVc, animated: true)}
        } else {
            showAlert(title: "Invalid Mail", message: "Please enter Valid EmailID.")
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
    

}
