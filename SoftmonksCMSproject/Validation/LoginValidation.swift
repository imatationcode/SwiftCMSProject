//
//  LoginValidation.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 19/02/24.
//

import UIKit

func isEmailValid(_ email:String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
   }

func isPasswordStrong(password: String) -> Bool {
    // Check if password has more than 6 characters
    guard password.count > 6 else {
        showAlert(title: "Invalid Password", message: "Password must be more than 6 characters long.")
        return false
    }
    // Check if password contains at least one number
    let numberPattern = ".*[0-9]+.*"
    let numberTest = NSPredicate(format: "SELF MATCHES %@", numberPattern)
    guard numberTest.evaluate(with: password) else {
        showAlert(title: "Invalid Password", message: "Password must contain at least one number.")
        return false
    }
    
    // Check if password contains at least one special character
    let specialCharacterPattern = ".*[!&^%$#@()/]+.*"
    
    let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterPattern)
    guard specialCharacterTest.evaluate(with: password) else {
        showAlert(title: "Invalid Password", message: "Password must contain at least one special character.")
        return false
    }
    
    return true

}

let vc = UIViewController()
func showAlert(title: String, message: String) {
  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
  vc.present(alert, animated: true, completion: nil)
}
    
