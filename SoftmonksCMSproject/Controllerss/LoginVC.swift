//
//  ViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 16/02/24.
//

import UIKit
import Alamofire

class LoginVc: UIViewController, LogoDisplayable, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var borderViewForEmail: UIView!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var borderViewForPassword: UIView!
    var loginData : loginCheck?
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        print("Loging ViewDIDLoad")
        super.viewDidLoad()
        addLogoToFooter()
        navigationItem.hidesBackButton = true
        updatePasswordVisibility()
        navigationController?.delegate = self
        
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
            let urlString = "https://monks.weblogicz.com/apps/softmonks.json?os=ios&v=1b1&b=SMK" //API endpoint
            let parameters = ["mode": "login", "username": mailAdd, "password": password]
            self.performLoginRequest(urlString: urlString, parameters: parameters)
        } else {
            showAlert(title: "Invalid Mail", message: "Please enter Valid EmailID.")
        }
        
        //
    }//loginPress button function close
    
    func performLoginRequest(urlString: String, parameters: [String: Any]) {
        print  ("in the performLogin")
        AF.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: loginCheck.self) { [weak self] response in  // Move switch statement closer
                guard let self = self else { return }
                switch response.result {
                case .success(let loginCheckData):
                    self.loginData = loginCheckData
                    // Handle successful login data retrieval
                    
                    guard loginCheckData.err == 0 else {
                        self.showAlert(title: "Login Failed", message: loginCheckData.errMsg)
                        
                        print(loginCheckData)  // Optional: For debugging purposes
                        return
                    }
                    
                    print(loginCheckData)  // Optional: For debugging purposes
                    LogManager.shared.setLoggedIn(true)
                    // Update UI using window scene (if needed)
                    print  ("in the performLogin")
                    self.navigateToMainPage()
                    
                case .failure(let error):
                    // Handle login data retrieval failure (including potential decoding errors)
                    print(error)
                    self.showAlert(title: "Login Error", message: error.localizedDescription)
                }
            }
    }
    //if Valid mail and Password
    
    func navigateToMainPage() {
        print("test")
        let profileVC = storyboard?.instantiateViewController(identifier: "ProfileMenuVC") as! ProfileMenuVC
        self.navigationController?.pushViewController(profileVC, animated: true)
        profileVC.username  = loginData?.name ?? ""
        profileVC.id  = loginData?.userId ?? ""
        
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        if let forgotPassword = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {navigationController?.pushViewController(forgotPassword, animated: true)}
        
        
    }
}



