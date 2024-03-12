//
//  ViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 16/02/24.
//

import UIKit

class LoginVc: UIViewController, LogoDisplayable, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var borderViewForEmail: UIView!
    
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var borderViewForPassword: UIView!
    
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        print("in te default Loging View DID Load")
        super.viewDidLoad()
        addLogoToFooter()
        updatePasswordVisibility()
        // Check if the user is already logged in
//        if isUserLoggedIn() {
//            navigateToMainPage()
//        }
        
 }
    @objc func doneButtonTapped() {
        view.endEditing(true)
        }
    @IBAction func tapEyeButton(_ sender: Any) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
    }
    
    private func updatePasswordVisibility() {
        // Update the text and image based on the password visibility state
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        let eyeIconImage = isPasswordVisible ? UIImage(named: "noVisibility") : UIImage(named: "visibility")
        eyeButton.setImage(eyeIconImage, for: .normal)
    }
    
    @IBAction func TappedLoginButtom(_ sender: Any) {
        guard let mailAdd = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
             let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            //  if both email and password are empty
            if mailAdd.isEmpty && password.isEmpty {
              showAlert(title: "Missing Fields", message: "Please enter your email address and password.")
              return
            }

            // if password is empty
            if password.isEmpty {
              showAlert(title: "Missing Password", message: "Please enter your password.")
              return
            }

            // if email is empty
            if mailAdd.isEmpty {
              showAlert(title: "Missing Email", message: "Please enter your email address.")
              return
            }
        if (isEmailValid(mailAdd) && !(password.isEmpty)) {
            LogManager.shared.setLoggedIn(true)
            print(LogManager.shared.isLoggedIn)
            navigateToMainPage()
            //print("Valid email address")
            // Set the user as logged in
            // setLoggedInStatus(true)
            // Navigate to the main page
        } else {
            showAlert(title: "Invalid Mail", message: "Please enter Valid EmailID.")
         }
        
          }//loginPress button function close
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let attributedTitle = NSAttributedString(string: title, attributes: [
            .foregroundColor : UIColor.red
          ])
          alertController.setValue(attributedTitle, forKey: "attributedTitle")
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
      }
        
    func navigateToMainPage() {
        if let profileMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileMenuVC") as? ProfileMenuVC {
            navigationController?.pushViewController(profileMenuVC, animated: true)
        }
    }
}


//
//    private func setLoggedInStatus(_ isLoggedIn: Bool) {
//        UserDefaults.standard.set(isLoggedIn, forKey: Keys.isLoggedIn)
//    }
//
//    private func isUserLoggedIn() -> Bool {
//        return UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
//    }


