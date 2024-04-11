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
    
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        print("in te default Loging View DID Load")
        super.viewDidLoad()
        addLogoToFooter()
        navigationItem.hidesBackButton = true
        updatePasswordVisibility()
        navigationController?.delegate = self
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
            //print("Valid email address")
            // Set the user as logged in
            // setLoggedInStatus(true)
            // Navigate to the main page
        } else {
            showAlert(title: "Invalid Mail", message: "Please enter Valid EmailID.")
         }
        let urlString = "https://monks.weblogicz.com/apps/softmonks.json?os=android&v=1b1&b=SMK&mode=login&T=1" //API endpoint
          let parameters = ["email": mailAdd, "password": password]

          //Making API call using Alamofire
        AF.request(urlString, method: .post, parameters: parameters).responseDecodable(of: loginCheck.self) { [weak self] response in
            guard let self = self else {
                return }
            switch response.result {
                
            case .success(let data):
              // Handle successful login
              self.handleLoginSuccess(data: data)
            case .failure(let error):
              // Handle login failure
              self.handleLoginFailure(error: error)
            }
          }
        
          }//loginPress button function close
    
    private func handleLoginSuccess(data: Any) {
      //Parse response for access token or other relevant data
      guard let jsonData = data as? [String: Any],
            let accessToken = jsonData["access_token"] as? String else {
        return
      }

      // Store access token securely (e.g., Keychain)
      UserDefaults.standard.set(accessToken, forKey: "accessToken")

      // Navigate to MainVC
        navigateToMainPage()
    }

    private func handleLoginFailure(error: Error) {
      // Display an error message to the user based on the error details
      let errorMessage = error.localizedDescription
        showAlert(title: "Login Error", message: "Please Check Your Credentials.")
    }
        
    //if Valid mail and Password
    
    func navigateToMainPage() {
        if let profileMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileMenuVC") as? ProfileMenuVC {
            navigationController?.pushViewController(profileMenuVC, animated: true)
        }
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        if let forgotPassword = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {navigationController?.pushViewController(forgotPassword, animated: true)}
     
        
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


