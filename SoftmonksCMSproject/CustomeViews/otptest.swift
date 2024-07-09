//
//  otptest.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 19/03/24.
//

import UIKit

class OTPView: UIStackView, UITextFieldDelegate {
    
    var textFieldArray = [UITextField]()
    var numberOfOTPdigit = 6
    var focusedControl: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setTextFields()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setTextFields()
    }
    private func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 10
    }
    private func setTextFields() {
        let red: CGFloat = 149.0 / 255.0
        let green: CGFloat = 204.0 / 255.0
        let blue: CGFloat = 255.0 / 255.0
        for index in 0..<numberOfOTPdigit {
            let field = UITextField()
            textFieldArray.append(field)
            addArrangedSubview(field)
            field.delegate = self
            field.tag = index
            field.keyboardType = .numberPad
            field.backgroundColor = .white
            field.textAlignment = .center
            field.layer.borderColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
            field.layer.borderWidth = 2.0
            field.layer.cornerRadius = 10.0
            field.clipsToBounds = true
            field.placeholder = "0"
            field.textColor = .black
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return false }
            let newLength = text.count + string.count - range.length

            // Allow backspace even if all fields are empty
            if string.isEmpty {
                return true
            }

            // Limit to single digit input per field
            if newLength > 1 {
                return false
            }
            // Move focus to the next text field when a digit is entered
            if newLength == 1 {
                let nextTag = textField.tag + 1
                if let nextField = viewWithTag(nextTag) as? UITextField {
                    DispatchQueue.main.async {
                        nextField.becomeFirstResponder()
                    }
                } else {
                    // All fields filled, handle completed OTP
                    DispatchQueue.main.async {
                        textField.resignFirstResponder()
                    }
                }
            }
            return true
        }
    
    func getEnteredOTP() -> String {
      return textFieldArray.compactMap { $0.text }.joined()
    }

    // Function to clear all text fields
    func clearTextFields() {
      for field in textFieldArray {
          field.text = ""
      }
        if let firstField = textFieldArray.first {
            firstField.becomeFirstResponder()
          }

    }
    
    func areAllFieldsFilled() -> Bool {
      for field in textFieldArray {
        if field.text?.isEmpty ?? true {
          return false
        }
      }
      return true
    }
}
