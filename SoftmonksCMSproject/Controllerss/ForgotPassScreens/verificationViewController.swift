//
//  verificationViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 18/03/24.
//

import UIKit

class verificationViewController: UIViewController, LogoDisplayable {
    private var timer: Timer?
    private var remainingTime = 60
    var isbuttonEnabeld = false
    @IBOutlet weak var otpStackVIew: OTPView!
    @IBOutlet weak var countDownlabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
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
            if let newpasswordVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPasswordVC") as? NewPasswordVC {navigationController?.pushViewController(newpasswordVc, animated: true)}
        }
    }
    
    @IBAction func resendOTPtapped(_ sender: Any) {
        startCountdownTimer()
          // Disable the resend button
        otpStackVIew.clearTextFields()
        resendButton.isEnabled = false
        
    }
    
}




