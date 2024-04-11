//
//  OTPDigitvalidationView.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 19/03/24.
//

import UIKit

class OTPDigitvalidationView: UIView{
    
    @IBOutlet weak var otpDigit1TextField: UITextField!
    @IBOutlet weak var otpDigit6TextField: UITextField!
    @IBOutlet weak var otpDigit5TextField: UITextField!
    @IBOutlet weak var otpDigit4TextField: UITextField!
    @IBOutlet weak var otpDigit3TextField: UITextField!
    @IBOutlet weak var otpDigit2TextField: UITextField!
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        print("Before inthe initframe")
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Before inthe initcoder")
        applyBorderStyling()
        //config()
        print("inthe initcoder")
        }
//    func config(){
//
//        applyBorderStyling([self.otpDigit1TextField,self.otpDigit2TextField,self.otpDigit6TextField,self.otpDigit4TextField,self.otpDigit3TextField,self.otpDigit5TextField])
//    }
    
    func applyBorderStyling() {
        // Set border color
        let red: CGFloat = 149.0 / 255.0
        let green: CGFloat = 204.0 / 255.0
        let blue: CGFloat = 255.0 / 255.0
        let textFields: [UITextField] = [self.otpDigit1TextField,self.otpDigit2TextField,self.otpDigit6TextField,self.otpDigit4TextField,self.otpDigit3TextField,self.otpDigit5TextField]
        for textField in textFields {
            textField.layer.borderColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
            // Set border width
            textField.layer.borderWidth = 2.0
            // Optionally, you can also round the corners
            textField.layer.cornerRadius = 10.0
            textField.clipsToBounds = true
        }
    }
}
