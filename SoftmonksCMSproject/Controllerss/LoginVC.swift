//
//  ViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 16/02/24.
//

import UIKit
import Alamofire
//import VariableTextsize

class LoginVc: UIViewController, LogoDisplayable, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var loginData : loginCheck?
    var isPasswordVisible = false
    let myId = UserDefaults.standard.object(forKey: "isLoggedIN")
    var initialTextFieldsFonts: [UITextField : UIFont] = [:]
    var initialLabelFonts: [UILabel : UIFont] = [:]
//    var initialButtonFonts: [UIButton: UIFont] = [:]
    
    @IBOutlet weak var passwordTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var loaderActivityIncicatior: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var borderViewForEmail: UIView!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var borderViewForPassword: UIView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
//    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        loaderActivityIncicatior.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        print("Loging ViewDIDLoad")//debug Purpose
        super.viewDidLoad()
        addLogoToFooter()
        navigationItem.hidesBackButton = true
        updatePasswordVisibility()
        print(UserDefaults.standard.object(forKey: "isLoggedIN"))
        navigationController?.delegate = self
//        storeInitialFonts()
        adjustFontSizeForDevice(textFields: [emailTextField, passwordTextField], labels: [emailTextLabel, passwordTextLabel])
      
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
            let urlString = apiURL //API endpoint
            let parameters = ["mode": "login", "username": mailAdd, "password": password]
            self.performLoginRequest(urlString: urlString, parameters: parameters)
        } else {
            showAlert(title: "Invalid Mail", message: "Please enter Valid EmailID.")
        }
        //
    }//loginPress button function close
    
    func performLoginRequest(urlString: String, parameters: [String: Any]) {
        loaderActivityIncicatior.startAnimating()
        print  ("in the performLogin")
        AF.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: loginCheck.self) { [weak self] response in  // Move switch statement closer
                guard let self = self else { return }
                switch response.result {
                case .success(let loginCheckData):
                    self.loginData = loginCheckData
                    print(loginCheckData.errMsg)
                    // Handle successful login data retrieval
                    guard loginCheckData.err == 0 else {
                        self.showAlert(title: "Login Failed", message: loginCheckData.errMsg ?? "")
                        print(loginCheckData.errMsg)
                        return
                    }
                    print(loginCheckData)
                    UserDefaults.standard.set(loginCheckData.userData.id, forKey: "isLoggedIN")
                    let UserDataDictionary = ["id": loginCheckData.userData.id, "name": loginCheckData.userData.name, "designation": loginCheckData.userData.designation]
                    
                    UserDefaults.standard.set(UserDataDictionary, forKey: "UserDetails")
                    self.loaderActivityIncicatior.stopAnimating()
                    self.navigateToMainPage()
                case .failure(let error):
                    self.loaderActivityIncicatior.stopAnimating()
                    print(error)
                    self.showAlert(title: "Login Error", message: "Please Re-Check Your Email and Password")
                }
            }
    }
    //if Valid mail and Password
    
    func navigateToMainPage() { //navigate to mainMenu page
        print("test")
        let profileVC = storyboard?.instantiateViewController(identifier: "ProfileMenuVC") as! ProfileMenuVC
        self.navigationController?.pushViewController(profileVC, animated: true)
        }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        if let forgotPassword = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {navigationController?.pushViewController(forgotPassword, animated: true)}
    }
}
