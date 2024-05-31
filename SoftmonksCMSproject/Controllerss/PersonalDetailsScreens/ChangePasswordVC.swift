//
//  ChangePasswordVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 23/05/24.
//

import UIKit

protocol changePassDelegate: AnyObject {
    func loggingOut()
}

class ChangePasswordVC: UIViewController, UITextFieldDelegate {
    weak var changePassdelegateVar: changePassDelegate?
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var popupVar: PasswordVarificationPopUpVC?
    var isPasswordVisible: Bool = false
    var varificationPop: PasswordVarificationPopUpVC?
    var newPassWordVar: String?
    var confirmPasswordVar: String?
    
    
    @IBOutlet weak var confirmPassLabel: UILabel!
    @IBOutlet weak var newpassLabel: UILabel!
    @IBOutlet weak var loaderActivityIncicatior: UIActivityIndicatorView!
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var eyeButton1: UIButton!
    @IBOutlet weak var eyeButton2: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFontSizeForDevice(textFields: [newPasswordTextField, confirmPasswordTextField], labels: [newpassLabel, confirmPassLabel])
        loaderActivityIncicatior.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        mainImageView.mainIconImage.image = UIImage(named: "Coloredkey")
        newPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }

    private func updatePasswordVisibility() {
        // Update the text and image based on the password visibility state
        newPasswordTextField.isSecureTextEntry = !isPasswordVisible
        confirmPasswordTextField.isSecureTextEntry = !isPasswordVisible
        let eyeIconImage = isPasswordVisible ? UIImage(named: "noVisibility") : UIImage(named: "visibility")
        eyeButton1.setImage(eyeIconImage, for: .normal)
        eyeButton2.setImage(eyeIconImage, for: .normal)
    }
    
    @IBAction func newPasswordEyeButtonTapped(_ sender: UIButton) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
    }
    
    @IBAction func confirmPasswordEyeButtonTapped(_ sender: UIButton) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        loaderActivityIncicatior.startAnimating()
        print("Submit Tapped")
        if performBasicOperations(){
            otpAPICall()
        } else{
            loaderActivityIncicatior.stopAnimating()
            return
            }
    }
   
    func otpAPICall() {
        let parameters: [String : Any] = ["mode": "createNewPassword", "id" : userDict?["id"], "newPassword" : newPassWordVar!, "confirmNewPassword" : confirmPasswordVar! ]
        passAPICall(parameters) { (success, errorMessage, uniqId) in
            if success {
                print(errorMessage)
                self.loaderActivityIncicatior.stopAnimating()
//                self.logOut()
                self.changePassdelegateVar?.loggingOut()
            } else {
                self.loaderActivityIncicatior.stopAnimating()
                self.showAlert(title: "Invalid Mail", message: errorMessage ?? "")
                return
            }
        }
    }
    
//    func logOut() {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "homeNavigationViewController") as? homeNavigationViewController {
//            vc.modalPresentationStyle = .fullScreen
//            UserDefaults.standard.removeObject(forKey: "isLoggedIN")
//            UserDefaults.standard.removeObject(forKey: "UserDetails")
//            self.present(vc, animated: true)
//            
//        }
//        
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when return key is tapped
        textField.resignFirstResponder()
        return true
    }
    
    func performBasicOperations() -> Bool {
        guard let password = newPasswordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text , !confirmPassword.isEmpty else {
            // Show an alert if any field is empty
            showAlert(title: "Error", message: "Please fill in both password fields.")
            return false
        }
        // Check if passwords match
        if password != confirmPassword {
            showAlert(title: "Error", message: "New Passwords & Confirm Password do not match. Please try again.")
            return false
        }
        newPassWordVar = password
        confirmPasswordVar = confirmPassword
        print("Password reset successful!")
        return true
    }
    

}

