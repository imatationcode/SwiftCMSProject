//
//  LeaveRequestVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 01/03/24.
//

import UIKit
import Alamofire

class LeaveRequestVC: UIViewController, LogoDisplayable, UITableViewDelegate, UITableViewDataSource, CellDelegate, LeaveApplicationPopUpDelegate {
    var leaveCell: LeaveData? = nil
    var saveLeveAPIRespons: DeleteAPIResponse?
    var leaveListData: [LeaveData] = []
    var initialAPIDataVar: LeaveResponse?
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var leaveApplicationPop: leaveApplicationPopUPViewController?
    var cellID: Int?
    @IBOutlet weak var leaveReuestsTableView: UITableView!
    @IBOutlet weak var totalLeavesLabel: UILabel!
    @IBOutlet weak var availabelLeavesLabel: UILabel!
    @IBOutlet weak var takenLeavesLabel: UILabel!
    @IBOutlet weak var leavesTakenTextLabel: UILabel!
    @IBOutlet weak var leavesAvailableTextlabel: UILabel!
    @IBOutlet weak var appliedLeaves: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFontSizeForDevice(textFields: [], labels: [appliedLeaves, leavesAvailableTextlabel,leavesTakenTextLabel, totalLeavesLabel, availabelLeavesLabel, takenLeavesLabel])
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Leave Requests"
        addLogoToFooter()
        self.leaveReuestsTableView.register(UINib(nibName: "appliedRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "appliedRequestTableViewCell")
        self.leaveReuestsTableView.register(UINib(nibName: "reviewedTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewedTableViewCell")
        initialLeaveDataFromAPI()
        self.leaveReuestsTableView.delegate = self
        self.leaveReuestsTableView.dataSource = self
        
    }
    
    func initialLeaveDataFromAPI(){
        
        let parameters: [String: Any] = ["mode": "initLeaveRequest", "id": userDict?["id"] ?? ""]
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: LeaveResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let leaveResponse):
//                    print(leaveResponse)
                    self.initialAPIDataVar = leaveResponse
                    self.configLayout()
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Error", message: "Error in API Call")
                }
            }
    }
    
    func configLayout() {
        self.leaveReuestsTableView.setContentOffset(CGPoint.zero, animated: true)
        totalLeavesLabel.text = initialAPIDataVar?.leaveTotal
        availabelLeavesLabel.text = initialAPIDataVar?.leaveAvailable
        takenLeavesLabel.text = initialAPIDataVar?.leaveTaken
        self.leaveListData = initialAPIDataVar?.leaveListData ?? []
        DispatchQueue.main.async {
            self.leaveReuestsTableView.reloadData()
        }
    }
    
   @objc func editButtonClicked(_ sender : UIButton){
        let vc = leaveApplicationPopUPViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaveListData.count
        //return DataService.instance.getLeaveRequests().count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leaveData = leaveListData[indexPath.row]
        
        if leaveData.inProcess == 0 {
            let cell = self.leaveReuestsTableView.dequeueReusableCell(withIdentifier: "appliedRequestTableViewCell", for: indexPath) as! appliedRequestTableViewCell
            cell.viewController = self
            cell.updateViews(leaveReuests: leaveData)
            cell.delegate = self
//            cell.editButton.addTarget(self, action: #selector(self.editButtonClicked(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = self.leaveReuestsTableView.dequeueReusableCell(withIdentifier: "reviewedTableViewCell", for: indexPath) as! reviewedTableViewCell
            cell.updateViews(leaveReuests: leaveData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isIpad() {
            return 200
        } else {
            return 130
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        initialLeaveDataFromAPI()
    }
    
    @IBAction func applyLeaveTapped(_ sender: Any) {

        leaveApplicationPop = leaveApplicationPopUPViewController()
        leaveApplicationPop?.delegateVariable = self
        leaveApplicationPop?.popUp(sender: self)
        
    }
    
    func deleteBtnPressed(forCell cell: appliedRequestTableViewCell) {
        print("InDelete")
        initialLeaveDataFromAPI()
    }
    
    func editAPICall(_ parameters : [String: Any]){
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: editAPIResponse.self) {[weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                     print (response)
                    let leaveApplicationPop = leaveApplicationPopUPViewController()
                    leaveApplicationPop.prefilledData = response.leaveData // Passing Prefill data
                    leaveApplicationPop.cellID = self.cellID
                    leaveApplicationPop.delegateVariable = self
                    leaveApplicationPop.popUp(sender: self)
//                    self.prefillResponse = response.leaveData
//                    self.passPrefillData()
                case .failure(let error):
                    print(error)
                }
            }
        //trigering the protocole
        
    }
    
    func editBtnPressed(forCell cell: appliedRequestTableViewCell, id: Int) {
        print(id)
        self.cellID = id
        let parameters: [String: Any] = ["mode" : "editLeaveRequest", "recordId" : id ]
        editAPICall(parameters)
    }
    
    func updateLeaveChanges(leaveType: String, fromDate: String, toDate: String, noOfDaysLeave: String, leaveReason: String, appliedDate: String) {
        let parameters: [String: Any] = ["mode" : "updateLeaveRequest", "id": userDict?["id"] ?? "","recordId": cellID!,"leaveType": leaveType, "fromDate": fromDate, "toDate": toDate, "appliedDate": appliedDate, "noOfDays": noOfDaysLeave, "reason": leaveReason]
        print(parameters)
    }
    
    func submitLeaveRequest(leaveType: String, fromDate: String, toDate: String, noOfDaysLeave: String, leaveReason: String, appliedDate: String, cellID: Int?) {
        print("inside submitLeaveRequest")
        if cellID == nil {
            let parameters: [String: Any] = ["mode" : "saveLeaveRequest", "id": userDict?["id"] ?? "","leaveType": leaveType, "fromDate": fromDate, "toDate": toDate, "appliedDate": appliedDate, "noOfDays": noOfDaysLeave, "reason": leaveReason]
            //        print(parameters)
            AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
                .responseDecodable(of: DeleteAPIResponse.self) {[weak self] response in
                    guard let self = self else {return}
                    switch response.result {
                    case .success(let response):
                        print (response)
                        self.saveLeveAPIRespons = response
                        if response.err == 1 {
                            self.showAlert(title:"Repeating Date", message: response.errMsg)
                        } else{
                            self.showAlert(title: "Success", message: response.errMsg)
                        }
                        self.initialLeaveDataFromAPI()
                    case .failure(let error):
                        print(error)
                    }
                }
        } else{
            print("\n INSIDE UPDATE API")
            let parameters: [String: Any] = ["mode" : "updateLeaveRequest", "id": userDict?["id"] ?? "","recordId": cellID!,"leaveType": leaveType, "fromDate": fromDate, "toDate": toDate, "appliedDate": appliedDate, "noOfDays": noOfDaysLeave, "reason": leaveReason]
            print("Here Is YOUR Parameter = \(parameters)")
            AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
                .responseDecodable(of: DeleteAPIResponse.self) {[weak self] response in
                    guard let self = self else {return}
                    switch response.result {
                    case .success(let response):
                        print (response)
                        self.saveLeveAPIRespons = response
                        if response.err == 1 {
                            self.showAlert(title:"Repeating Date", message: response.errMsg)
                        } else{
                            self.showAlert(title: "Success", message: response.errMsg)
                        }
                        self.initialLeaveDataFromAPI()
                    case .failure(let error):
                        print(error)
                    }
                }
            
        }
    }
    

}//class END
extension UIViewController {
    func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
