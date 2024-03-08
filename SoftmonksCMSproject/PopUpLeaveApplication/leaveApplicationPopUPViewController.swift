//
//  leaveApplicationPopUPViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 07/03/24.
//

import UIKit

class leaveApplicationPopUPViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var popupContentView: UIView!
    @IBOutlet weak var selectedLeaveType: UITextField!
    
    let leaveTypes = ["Full Day", "Morning Half-Day", "Afternoon Half-Day"]
    
    lazy var pickerView: UIPickerView = {
            let picker = UIPickerView()
            picker.dataSource = self
            picker.delegate = self
            return picker
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conFigView()
        selectedLeaveType.inputView = pickerView
        
        let toolbar = UIToolbar()
                toolbar.sizeToFit()
                
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        selectedLeaveType.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leaveTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leaveTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLeaveType.text = leaveTypes[row]
    }
    @objc func doneButtonPressed() {
            selectedLeaveType.resignFirstResponder()
        }
    @IBAction func sendLeaveRequest(_ sender: Any) {
        hide()
        
    }
    
    init() {
        super.init(nibName: "leaveApplicationPopUPViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func conFigView() {
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
        }
        
    }
    
    
}
