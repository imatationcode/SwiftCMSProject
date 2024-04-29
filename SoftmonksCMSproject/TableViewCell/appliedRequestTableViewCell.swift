//
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
//        func editBtnPressed(forCell cell: appliedRequestTableViewCell)
    }

class appliedRequestTableViewCell: UITableViewCell {
    var leaveCell: LeaveData? = nil
    //adding delegae property
    weak var delegate: CellDelegate?
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var appliedOnDateLabel: UILabel!
    @IBOutlet weak var NoOfDaysLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var inProgressView: UIView!
    
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
        
        let id: Int = leaveCell?.recordId ?? 0
        print(id)
        let parameters: [String: Any] = ["mode" : "deleteLeaveRequest", "recordId" : id ]
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: DeleteAPIResponse.self) {[weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    print (response)
                    let message = response.errMsg
                    self.showAlert(title: "Success", message: message ?? "")
                case .failure(let error):
                    print(error)
                }
            }
        //trigering the protocole
        delegate?.deleteBtnPressed(forCell: self)
    }
    
    @IBAction func tappedOnEdit(_ sender: Any) {
        delegate?.deleteBtnPressed(forCell: self)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inProgressView.onlyCornerRadius(conRadius: 10.0)
        outterView.onlyCornerRadius(conRadius: 8.0)
        addElevatedShadow(to: outterView)
        
        // Initialization code
    }
    
    
    weak var viewController: UIViewController?
    
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
//
//        // Configure the view for the selected state
//    }
    

