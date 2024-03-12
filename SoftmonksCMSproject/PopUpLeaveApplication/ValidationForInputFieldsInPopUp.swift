//
//  ValidationForInputFieldsInPopUp.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 11/03/24.
//

import UIKit

func validateTextFields(textField1: UITextField, textField2: UITextField, textField3: UITextField, viewController: UIViewController) -> Bool {
  if textField1.text!.isEmpty || textField2.text!.isEmpty || textField3.text!.isEmpty {
      print(textField2)
    showAlert(viewController: viewController, message: "Please fill in all fields.")
    
    return false
  }
    print(textField2)
//
// let date2 = formatDate(textField2.text)
// let date3 = formatDate(textField3.text)
//
//
//  if date2 >= date3 {
//    showAlert(viewController: viewController, message: "From Date must be earlier than To Date .")
//    return false
//  }

  return true
}

// Helper function to format date strings
//private func formatDate(_ dateString: String) -> Date? {
//  let formatter = DateFormatter()
//  formatter.dateFormat = "YYYY-MM-DD"  // Adjust format as needed
//  return formatter.date(from: dateString)
//}

// Helper function to show alert with a generic message
private func showAlert(viewController: UIViewController, message: String) {
  let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
  let action = UIAlertAction(title: "OK", style: .default, handler: nil)
  alert.addAction(action)
  viewController.present(alert, animated: true, completion: nil)
}
