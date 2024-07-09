//
//  PasswordVarificationPopUpVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 24/05/24.
//

import UIKit

protocol PasswordVarificationPopUpVCDelegate: AnyObject {
    func dismissPopUp()
}

class PasswordVarificationPopUpVC: UIViewController {
    
    var isPasswordVisible: Bool = false
    
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    weak var delegate: PasswordVarificationPopUpVCDelegate?
    var enteredPasswordVar: String?
    
    
    @IBOutlet weak var verificationTextLabel: UILabel!
    @IBOutlet var parentBackView: UIView!
    @IBOutlet weak var crossButtonView: UIView!
    @IBOutlet weak var backTransperantView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var oldPasswordTextFields: UITextField!
    @IBOutlet weak var curentPassTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDesign()
        updatePasswordVisibility()
        oldPasswordTextFields.isSecureTextEntry = !isPasswordVisible
        adjustFontSizeForDevice(textFields: [oldPasswordTextFields], labels: [verificationTextLabel, curentPassTextLabel])
    }
    
    func initialDesign() {
        contentView.layer.cornerRadius = 8.0
        crossButtonView.layer.cornerRadius = 3.0
        crossButtonView.addElevatedShadow(to: crossButtonView)
        backTransperantView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    
    @IBAction func tappedOnCrossButton(_ sender: Any) {
        delegate?.dismissPopUp()
        self.dismiss(animated: true, completion: nil)
        
        }
    
    
    private func updatePasswordVisibility() {
        // Update the text and image based on the password visibility state
        oldPasswordTextFields.isSecureTextEntry = !isPasswordVisible
        let eyeIconImage = isPasswordVisible ? UIImage(named: "noVisibility") : UIImage(named: "visibility")
        eyeButton.setImage(eyeIconImage, for: .normal)
    }

    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("Submit Tapped")
        if performBasicOperations(){
            otpAPICall()
        } else{
            return
            }
    }
   
    func otpAPICall() {
        let parameters: [String : Any] = ["mode": "confirmOldPassword", "id" : userDict?["id"]!, "oldPassword" : enteredPasswordVar!]
        passAPICall(parameters) { (success, errorMessage, uniqId) in
            if success {
                print(errorMessage as Any)
                self.dismiss(animated: true, completion: nil)
//                self.loaderActivityIncicatior.stopAnimating()shivakum
//                self.delegate?.loggingOut()
            } else {
//                self.loaderActivityIncicatior.stopAnimating()
                self.showAlert(title: "Invalid", message: errorMessage ?? "")
                return
            }
        }
    }
        // Function to perform basic operations on text fields
    func performBasicOperations() -> Bool {
        guard let password = oldPasswordTextFields.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in password fields.")
            return false
        }
        self.enteredPasswordVar = password
        return true
    }
               
}

