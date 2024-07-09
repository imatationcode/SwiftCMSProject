//
//  verificationViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 18/03/24.
//

import UIKit
import Alamofire


class VerificationViewController: UIViewController, LogoDisplayable {
    private var timer: Timer?
    private var remainingTime = 60
    
    var eMailId: String?
    var isbuttonEnabeld = false
    
    @IBOutlet weak var inWordLabel: UILabel!
    @IBOutlet weak var otpNotReceivedMessage: UILabel!
    @IBOutlet weak var instructionMessageLabel: UILabel!
    @IBOutlet weak var loaderActivityIncicatior: UIActivityIndicatorView!
    @IBOutlet weak var otpStackVIew: OTPView!
    @IBOutlet weak var countDownlabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFontSizeForDevice(textFields: [], labels: [countDownlabel, inWordLabel, instructionMessageLabel, otpNotReceivedMessage ])
        print("email in verificatio = \(eMailId)")
        loaderActivityIncicatior.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        addLogoToFooter()
        mainImageView.mainIconImage.image = UIImage(named: "MailwithTickmark")
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Verification"
        navigationItem.hidesBackButton = true
        resendButton.isEnabled = isbuttonEnabeld
        startCountdownTimer()
        
    }
    
    func startCountdownTimer() {
        remainingTime = 60 // Reset remaining time
        countDownlabel.text = String(format: "%02d", remainingTime) // Display initial time
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return } // Avoid retaining cycles
            
            self.remainingTime -= 1
            self.countDownlabel.text = String(format: "%02d", self.remainingTime)
            
            if self.remainingTime == 0 {
                self.timer?.invalidate()
                self.timer = nil
                // Disable interaction with the label (optional)
                self.countDownlabel.isUserInteractionEnabled = false
                
                self.resendButton.isEnabled = true
            }
        }
    }
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        if !otpStackVIew.areAllFieldsFilled() {
            // Display an alert if any OTP field is empty
            let alertController = UIAlertController(title: "Error", message: "Please fill all OTP fields.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let otp = otpStackVIew.getEnteredOTP()
            let perameters: [String : Any] = ["mode":"verifyOTP", "username": eMailId!, "otp":otp]
            passAPICall(perameters) { (success, errorMessage, uniqId) in
                if success {
                    self.loaderActivityIncicatior.stopAnimating()
                    print("all ok")
                    if let newpasswordVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPasswordVC") as? NewPasswordVC {
                        newpasswordVc.emailID = self.eMailId; newpasswordVc.employeeID = uniqId ; self.navigationController?.pushViewController(newpasswordVc, animated: true)}
                } else {
                    print("not all ok")
                    self.loaderActivityIncicatior.stopAnimating()
                    self.showAlert(title: "Invalid", message: errorMessage ?? "")
                    return
                }
            }
        }
    }
    
    
    @IBAction func resendOTPtapped(_ sender: Any) {
        startCountdownTimer()
        // Disable the resend button
        otpStackVIew.clearTextFields()
        resendButton.isEnabled = false
        resendOtpAPICall()
        print("resend End")
        
    }
    
    
    func resendOtpAPICall() {
        
        guard let mailID = eMailId else {
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
                            self.showAlert(title: "OTP Resent", message: "A new OTP has been sent to your email address. Please check your inbox.")
                            return
                        }
                        
                        if let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            if let errMsg = responseJSON["errMsg"] as? String, !errMsg.isEmpty {
                                let errTitle = responseJSON["errTitle"] as? String ?? "Error"
                                self.showAlert(title: errTitle, message: errMsg)
                            } else {
                                self.showAlert(title: "OTP Resent", message: "A new OTP has been sent to your email address. Please check your inbox.")
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
}




