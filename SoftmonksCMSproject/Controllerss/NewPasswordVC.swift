//
//  NewPasswordVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 19/03/24.
//

import UIKit

class NewPasswordVC: UIViewController, LogoDisplayable, UITextFieldDelegate {
    
    var isPasswordVisible = false

    @IBOutlet weak var confirmPassEyeButton: UIButton!
    @IBOutlet weak var newpassEyeButton: UIButton!
    @IBOutlet weak var confirmPasswordTextfields: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var mainImageIconView: ProfileImageCustomeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogoToFooter()
        mainImageIconView.mainIconImage.image = UIImage(named: "LockIcon")
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Create New Password"
        navigationItem.hidesBackButton = true
        newPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextfields.isSecureTextEntry = true
    }
    
    @IBAction func eyeButton1Tapped(_ sender: Any) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
    
}
    @IBAction func eye2ButtonConfirmpass(_ sender: Any) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
        
    }
    

private func updatePasswordVisibility() {
    // Update the text and image based on the password visibility state
    newPasswordTextField.isSecureTextEntry = !isPasswordVisible
    confirmPasswordTextfields.isSecureTextEntry = !isPasswordVisible
    let eyeIconImage = isPasswordVisible ? UIImage(named: "noVisibility") : UIImage(named: "visibility")
    newpassEyeButton.setImage(eyeIconImage, for: .normal)
    confirmPassEyeButton.setImage(eyeIconImage, for: .normal)
}
    
    @IBAction func resetButtonTappeed(_ sender: Any) {
        if !performBasicOperations(){
            return
        } else{
                if let passwordResetCompletionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasswordResetCompletionVC") as? PasswordResetCompletionVC {navigationController?.pushViewController(passwordResetCompletionVC, animated: true)}
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when return key is tapped
            textField.resignFirstResponder()
            return true
        }
        // Function to perform basic operations on text fields
        func performBasicOperations() -> Bool {
            guard let password = newPasswordTextField.text, !password.isEmpty,
                  let confirmPassword = confirmPasswordTextfields.text, !confirmPassword.isEmpty else {
                // Show an alert if any field is empty
                showAlert(title: "Error", message: "Please fill in both password fields.")
                return false
            }
            // Check if passwords match
            if password != confirmPassword {
                showAlert(title: "Error", message: "New Passwords & Confirem Password do not match. Please try again.")
                return false
            }
            
            print("Password reset successful!")
            return true
        }

    

}
