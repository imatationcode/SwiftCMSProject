//
//  SalaryDetailsViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 30/05/24.
//

import UIKit

class SalaryDetailsViewController: UIViewController, LogoDisplayable, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var salarySlipsTableView: UITableView!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    
    let monthPickerView = UIPickerView()
    let yearPickerView  = UIPickerView()
    
    // Data for the picker
    let months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    var years: [Int] = []
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Salary Reciepts"
        salarySlipsTableView.register(UINib(nibName: "SalaryReciptsTableViewCell", bundle: nil), forCellReuseIdentifier: "SalaryReciptsTableViewCell")
        salarySlipsTableView.dataSource = self
        salarySlipsTableView.delegate = self
        adjustableTableCellSize(for: salarySlipsTableView, iPadSize: 80, iPhoneSize: 50)
        addLogoToFooter()
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(2015...currentYear)
        
        monthTextField.inputView = monthPickerView
        yearTextField.inputView = yearPickerView
        
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        
        yearPickerView.delegate = self
        yearPickerView.delegate = self
        
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
        toolbar.sizeToFit()
        toolbar.alpha = 1.0
        //toolbar buttons
        let DonebuttonIcon = UIImage(named: "Done20")
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
        doneButton.image = DonebuttonIcon
        let cancelIcone = UIImage(named: "Cancel20")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
        cancelButton.image = cancelIcone
        let spaceBetween = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceBetween,doneButton], animated: true)
        
        monthTextField.inputAccessoryView = toolbar
        yearTextField.inputAccessoryView = toolbar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = salarySlipsTableView.dequeueReusableCell(withIdentifier: "SalaryReciptsTableViewCell", for: indexPath)
        return cell
    }
    
    @objc func dismissPicker(_ sender: UITapGestureRecognizer) {
        if sender.view === view && !yearTextField.isFirstResponder && !monthTextField.isFirstResponder {
            view.endEditing(true) // Dismiss picker if tapped outside and none of the text fields are first responders
        }
    }
    @objc func donePressed() {
        // Dismiss the picker
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === monthPickerView {
            return months.count
        } else if pickerView === yearPickerView {
            return years.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === monthPickerView {
            monthTextField.text = months[row]
        } else if pickerView === yearPickerView {
            yearTextField.text = String(years[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        if pickerView === monthPickerView {
            label.text = months[row]
        } else if pickerView === yearPickerView {
            label.text = String(years[row])
        }
        return label
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
