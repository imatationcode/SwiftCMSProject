//  newTableViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 06/03/24.
//

import UIKit
import Alamofire

//protocole defining
    protocol CellDelegate: AnyObject {
        func deleteBtnPressed (forCell cell: appliedRequestTableViewCell)
        func editBtnPressed(forCell cell: appliedRequestTableViewCell, id: Int)
    }

class appliedRequestTableViewCell: UITableViewCell {
    
    var leaveCell: LeaveData? = nil
    //adding delegae property
    weak var delegate: CellDelegate?
    var prefillResponse: editLeaveData?
    let popupViewControllerVariable = leaveApplicationPopUPViewController()
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var appliedOnDateLabel: UILabel!
    @IBOutlet weak var NoOfDaysLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var inProgressView: UIView!
    @IBOutlet weak var inprocessTextLabel: UILabel!
    @IBOutlet weak var dashLabel: UILabel!
    @IBOutlet weak var noOfDaysTextLabel: UILabel!
    @IBOutlet weak var appliedOnTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inProgressView.onlyCornerRadius(conRadius: 10.0)
        outterView.onlyCornerRadius(conRadius: 8.0)
        addElevatedShadow(to: outterView)
        adjustFontSizeForDevice(textFields: [], labels: [appliedOnDateLabel,appliedOnTextLabel, NoOfDaysLabel, noOfDaysTextLabel, fromDateLabel, dashLabel, toDateLabel, leaveTypeLabel, inprocessTextLabel])
        
        
        // Initialization code
    }
    
    
    func updateViews(leaveReuests: LeaveData){
        leaveCell = leaveReuests
        appliedOnDateLabel.text = leaveReuests.appliedDate
        fromDateLabel.text = leaveReuests.fromDate
        toDateLabel.text = leaveReuests.toDate
        NoOfDaysLabel.text = leaveReuests.noOfDays
        let leaveTypeMap: [String: String] = [
            "fd": "Full Day",
            "mhd": "Morning Half Day",
            "ehd": "Evening Half Day"
            // Add more mappings as needed
        ]
        
        // Set leaveTypeLabel text based on the mapping
        if let leaveTypeText = leaveTypeMap[leaveReuests.leaveType ?? ""] {
            leaveTypeLabel.text = leaveTypeText
        } else {
            leaveTypeLabel.text = leaveReuests.leaveType
        }
    }
    
    @IBAction func tappedOnDelete(_ sender: Any) {
        let id: Int = (leaveCell?.recordId)!
        print(id)
        let parameters: [String: Any] = ["mode" : "deleteLeaveRequest", "recordId" : id ]
        //editAPICall(parameters)
        deleteAlert(title: "Warning!", message: "Are you sure", viewController: self.viewController) { delete in
            AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
                .responseDecodable(of: DeleteAPIResponse.self) {[weak self] response in
                    guard let self = self else {return}
                    switch response.result {
                    case .success(let response):
                        print (response)
                        self.delegate?.deleteBtnPressed(forCell: self)
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
    
    @IBAction func tappedOnEdit(_ sender: UIButton) {
        let id: Int = leaveCell?.recordId ?? 0
        self.delegate?.editBtnPressed(forCell: self, id: id)
//        let parameters: [String: Any] = ["mode" : "editLeaveRequest", "recordId" : id ]
//        editAPICall(parameters)

    }
    

    
    func editAPICall(_ parameters : [String: Any]){
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: editAPIResponse.self) {[weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                     print (response)
                    self.delegate?.deleteBtnPressed(forCell: self)
//                    self.prefillResponse = response.leaveData
//                    self.passPrefillData()
                case .failure(let error):
                    print(error)
                }
            }
        //trigering the protocole
        
    }
    
    func passPrefillData(){
        print(prefillResponse)
        let leavePrefillVC = leaveApplicationPopUPViewController()
        leavePrefillVC.prefilledData = prefillResponse
//        delegate?.editBtnPressed(forCell: self)
        }
    
    
    weak var viewController: UIViewController?
    
    func deleteAlert(title: String, message: String, viewController: UIViewController?, deleteHandler: ((UIAlertAction) -> Void)?) {
        guard let viewController = viewController else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String) {
        guard let viewController = viewController else {
            print("View controller is nil. Cannot present alert.")
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
    



















