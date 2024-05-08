//
//  leaveApplicationPopUPViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 07/03/24.
//

import UIKit
import Alamofire

protocol LeaveApplicationPopUpDelegate: AnyObject {
    func submitLeaveRequest(leaveType: String, fromDate: String, toDate: String, noOfDaysLeave: String, leaveReason: String, appliedDate: String, cellID: Int?)
    func updateLeaveChanges(leaveType: String, fromDate: String, toDate: String, noOfDaysLeave: String, leaveReason: String, appliedDate: String)
}

class leaveApplicationPopUPViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    var prefilledData: editLeaveData?
    var crossBtn = 0
    var cellID: Int?
    let leaveTypes: [String: String] = ["fd": "Full Day", "mhd": "Morning Half Day", "ehd": "Evening Half Day"]
    var focusedControl: UITextField?
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var fromDate: String?
    var toDate: String?
    var noOfDaysLeave: String?
    var selectedLeaveTypestring: String?
    var leaveReason: String?
    var noofdays = 0.0
    var leaveTypeKey: String?
//    var saveLeveAPIRespons: DeleteAPIResponse?
    var delegateVariable: LeaveApplicationPopUpDelegate?

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var popupContentView: UIView!
    @IBOutlet weak var selectedLeaveType: UITextField!
    @IBOutlet weak var noOfDaysLabel: UILabel!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var crossButtonView: UIView!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var fromDateView: DesingsForUIView!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var toDateView: DesingsForUIView!
    @IBOutlet weak var leaveReasonTextView: UITextView!
    @IBOutlet weak var sendLeaveMainButton: UIButton!
    
    lazy var leavepickerView: UIPickerView = {
            let picker = UIPickerView()
            picker.dataSource = self
            picker.delegate = self
            return picker
        }()
    lazy var fromDateDatePicker: UIDatePicker = {
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.addTarget(self, action: #selector(fromDateDatePickerValueChanged(_:)), for: .valueChanged)
            picker.frame.size = CGSize(width: 0.0, height: 200)
            picker.preferredDatePickerStyle = .wheels
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            picker.minimumDate = tomorrow
            return picker
       }()
   lazy var toDateDatePicker: UIDatePicker = {
           let picker = UIDatePicker()
           picker.datePickerMode = .date
           picker.addTarget(self, action: #selector(toDateDatePickerValueChanged(_:)), for: .valueChanged)
           picker.frame.size = CGSize(width: 0.0, height: 200)
           picker.preferredDatePickerStyle = .wheels
           return picker
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLeaveType.delegate = self
        crossButtonView.addElevatedShadow(to: crossButtonView)
        crossButtonView.layer.cornerRadius = 3.0
        selectedLeaveType.inputView = leavepickerView
        fromDateTextField.inputView = fromDateDatePicker
        toDateTextField.inputView = toDateDatePicker
        conFigView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender: )))
        view.addGestureRecognizer(gesture)
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
        toolbar.sizeToFit()
        toolbar.alpha = 1.0
        //toolbar buttons
        let DonebuttonIcon = UIImage(named: "Done20")
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonTapped))
        doneButton.image = DonebuttonIcon
        let cancelIcone = UIImage(named: "Cancel20")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelButtonTapped))
        cancelButton.image = cancelIcone
        let spaceBetween = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceBetween,doneButton], animated: true)
        selectedLeaveType.inputAccessoryView = toolbar
        fromDateTextField.inputAccessoryView = toolbar
        toDateTextField.inputAccessoryView = toolbar
        
        print(" Here is Prefile \(prefilledData)")
        
        if prefilledData == nil {
            sendLeaveMainButton.setTitle("Send Leave Request", for: .normal)
            fromDateTextField.isEnabled = false
            toDateTextField.isEnabled = false
            cellID = nil
        } else {
            
            sendLeaveMainButton.setTitle("Update Changes", for: .normal)
            toPrefillData()
            
        }
        
    }//ViewDidLoadEndsHere
    
    func toPrefillData() {
        guard let prefilledLeaveType = leaveTypes[prefilledData?.leaveType ?? ""] else { return  }
                if let row = Array(leaveTypes.values).firstIndex(of: prefilledLeaveType) {
                    pickerView(leavepickerView, didSelectRow: row, inComponent: 0)
                }
            
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            if let prefilledFromDate = prefilledData?.fromDate {
                if let fromDate = dateFormatter.date(from: prefilledFromDate) {
                    fromDateDatePicker.date = fromDate
                    fromDateDatePickerValueChanged(fromDateDatePicker) // Trigger value changed event
                }
            }

            if let prefilledToDate = prefilledData?.toDate {
                if let toDate = dateFormatter.date(from: prefilledToDate) {
                    toDateDatePicker.date = toDate
                    toDateDatePickerValueChanged(toDateDatePicker) // Trigger value changed event
                }
            }
        noOfDaysLabel.text = prefilledData?.noOfDays
        leaveReasonTextView.text = prefilledData?.reason
        fromDateTextField.isEnabled = true
        toDateTextField.isEnabled = true
    }
    
    func textFieldDidChangeSelection(_ sender: UITextField) {
        if sender === selectedLeaveType {
            let dataStatus = enableNextTextField(currentField: selectedLeaveType, nextField: fromDateTextField)
            if (dataStatus){
                fromDateView.isHidden = false
                fromDateLabel.isHidden = false
            }
            
        } else if sender === fromDateTextField {
            let dataStatus = enableNextTextField(currentField: fromDateTextField, nextField: toDateTextField)
            if (dataStatus){
                toDateView.isHidden = false
                toDateLabel.isHidden = false
            }
        }
    }
    
    func enableNextTextField(currentField: UITextField, nextField: UITextField) -> Bool {
         nextField.isEnabled = !currentField.text!.isEmpty // Enable next field if current field has text
        return nextField.isEnabled
     }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === selectedLeaveType {
            let selectedRow = pickerView(leavepickerView, numberOfRowsInComponent: 0) / 2 // Select the middle row initially
            pickerView(leavepickerView, didSelectRow: selectedRow, inComponent: 0)
        } else if textField === fromDateTextField {
            let currentDate = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            fromDateDatePicker.date = tomorrow ?? currentDate // Set initial date to tomorrow
            fromDateDatePickerValueChanged(fromDateDatePicker) // Update the text field and calculate days
        } else if textField === toDateTextField {
            let currentDate = Date()
            toDateDatePicker.date = currentDate // Set initial date to current date
            toDateDatePickerValueChanged(toDateDatePicker) // Update the text field and calculate days
        }
//        self.focusedControl = textField
      }


    @objc func fromDateDatePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        toDateDatePicker.minimumDate = selectedDate
        updateDateTextField(fromDateTextField, with: sender.date)
        toDateTextField.text = ""
        noOfDaysLabel.text = "00"
        calculateAndDisplayDaysBetweenDates()
        
    }

     @objc func toDateDatePickerValueChanged(_ sender: UIDatePicker) {
         updateDateTextField(toDateTextField, with: sender.date)
         calculateAndDisplayDaysBetweenDates()
     }
    func calculateAndDisplayDaysBetweenDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let fromDate = fromDateDatePicker.date
        let toDate = toDateDatePicker.date
        self.fromDate = dateFormatter.string(from: fromDate)
        self.toDate = dateFormatter.string(from: toDate)
        let todateText = toDateTextField.text
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        let daysBetween: Double = Double(components.day ?? 0)
        self.leaveTypeKey = getKeyForLeaveType(selectedLeaveType.text ?? "")
        if leaveTypeKey != "fd" {
            self.noofdays = ((daysBetween + 1.0) * 0.5)
        } else {
            self.noofdays = daysBetween + 1.0
        }
        // Update label with the number of days
        noOfDaysLabel.text = "\(noofdays)"
        self.noOfDaysLeave = noOfDaysLabel.text

    }
    
    func getKeyForLeaveType(_ leaveTypeText: String) -> String? {
        let leaveTypeMapping: [String: String] = [
            "Full Day": "fd",
            "Morning Half Day": "mhd",
            "Evening Half Day": "ehd"
        ]
        
        return leaveTypeMapping[leaveTypeText]
    }

    private func updateDateTextField(_ textField: UITextField, with date: Date) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy"
           textField.text = dateFormatter.string(from: date)
       }
    
    func numberOfComponents(in leavepickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ leavepickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leaveTypes.count
    }
    
    func pickerView(_ leavepickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let key = Array(leaveTypes.keys)[row]
        return leaveTypes[key]
    }
    
    func pickerView(_ leavepickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = Array(leaveTypes.keys)[row]
        selectedLeaveType.text = leaveTypes[key]
        calculateAndDisplayDaysBetweenDates()
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
//        leaveReason = leaveReasonTextView.text
            selectedLeaveType.resignFirstResponder()
            fromDateTextField.resignFirstResponder() // Dismiss the date picker
            toDateTextField.resignFirstResponder()
        }
    
    @objc func cancelButtonTapped(){
        selectedLeaveType.text = ""
        fromDateTextField.text = ""
        toDateTextField.text = ""
        leaveReason = ""
        view.endEditing(true)
    }
    //Validating  data on press of send leave request button then sending it to main  list screen
    @IBAction func sendLeaveRequest(_ sender: Any) {
        print(leaveReasonTextView.text!)
        if validateTextFields(textField1: selectedLeaveType, textField2: fromDateTextField, textField3: toDateTextField,leaveReason: leaveReasonTextView, viewController: self) {
            leaveReason = leaveReasonTextView.text
            hide()
//            addLeaveRequestAPICall()
        }
    }
    
    //Converting it as an popup
    
    init() {
        super.init(nibName: "leaveApplicationPopUPViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func conFigView() {
        self.leaveReasonTextView.layer.borderColor = UIColor(red: 147/255, green: 203/255, blue: 255/255, alpha: 1.0).cgColor
        self.leaveReasonTextView.layer.borderWidth = 2.0
        self.leaveReasonTextView.layer.cornerRadius = 10.0
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.popupContentView.alpha = 0
        self.popupContentView.layer.cornerRadius = 10
    }
    
    func popUp(sender: UIViewController) {
        sender.present(self, animated: true)
        self.showup()
        
    }
    
    private func showup(){
        UIView.animate(withDuration: 0.2, delay: 0.0){
            self.backView.alpha = 1
            self.popupContentView.alpha = 1
            
        }
    }
     
    func hide() {
        UIView.animate(withDuration: 0.2, delay: 0.0){
            self.backView.alpha = 0
            self.popupContentView.alpha = 0
            
        } completion: { _ in
            self.dismiss(animated: true)
            self.removeFromParent()
            if(self.crossBtn == 0) {
                self.addLeaveRequestAPICall()
                print("inside hide COMPLITION")
            } else {
                self.crossBtn = 0
            }
//            self.updateLeaveRequestAPICall()
        }
        
    }
    
    @IBAction func crossButtonTaped(_ sender: Any) {
        crossBtn = 1
        hide()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func setupToolbar(){
            //Create a toolbar
            let bar = UIToolbar()
            //Create a done button with an action to trigger our function to dismiss the keyboard
            let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
            //Create a felxible space item so that we can add it around in toolbar to position our done button
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            //Add the created button items in the toobar
            bar.items = [flexSpace, flexSpace, doneBtn]
            bar.sizeToFit()
            //Add the toolbar to our textfield
            selectedLeaveType.inputAccessoryView = bar
        }
    //function to return system date
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    func addLeaveRequestAPICall(){
        print(leaveTypeKey)
        guard let leaveType = leaveTypeKey,
          let fromDate = fromDate,
          let toDate = toDate,
          let noOfDaysLeave = noOfDaysLeave,
          let leaveReason = leaveReason else { return }
          let currentDate = getCurrentDate()
          print("inside hide AddLIReq")
        
        
//      guard let leaveType = leaveTypeKey,
//        let fromDate = fromDate,
//        let toDate = toDate,
//        let noOfDaysLeave = noOfDaysLeave,
//        let leaveReason = leaveReason else { return }
//        let currentDate = getCurrentDate()
//        print("inside hide AddLIReq")
        //passing data to the api call on the main leave list screen
        delegateVariable?.submitLeaveRequest(leaveType: leaveType, fromDate: fromDate, toDate: toDate, noOfDaysLeave: noOfDaysLeave, leaveReason: leaveReason, appliedDate: currentDate, cellID: cellID)
        }
    
        @objc func dismissMyKeyboard(){
            view.endEditing(true)
        }
    
//    func updateLeaveRequestAPICall() {
//        guard let leaveType = leaveTypeKey,
//          let fromDate = fromDate,
//          let toDate = toDate,
//          let noOfDaysLeave = noOfDaysLeave,
//          let leaveReason = leaveReason else { return }
//          let currentDate = getCurrentDate()
//          delegateVariable?.updateLeaveChanges(leaveType: leaveType, fromDate: fromDate, toDate: toDate, noOfDaysLeave: noOfDaysLeave, leaveReason: leaveReason, appliedDate: currentDate)
//        }
        
    }
