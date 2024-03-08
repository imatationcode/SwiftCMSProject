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
