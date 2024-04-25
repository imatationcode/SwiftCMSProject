//
//  LeaveRequestVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 01/03/24.
//

import UIKit
import Alamofire

class LeaveRequestVC: UIViewController, LogoDisplayable, UITableViewDelegate, UITableViewDataSource, CellDelegate {
    var leaveListData: [LeaveData] = []
    var initialAPIDataVar: LeaveResponse?
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    
    @IBOutlet weak var leaveReuestsTableView: UITableView!
    @IBOutlet weak var totalLeavesLabel: UILabel!
    @IBOutlet weak var availabelLeavesLabel: UILabel!
    @IBOutlet weak var takenLeavesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    print(leaveResponse)
                    self.initialAPIDataVar = leaveResponse
                    self.configLayout()
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Error", message: "Error in API Call")
                }
            }
    }
    
    func configLayout() {
        totalLeavesLabel.text = initialAPIDataVar?.leaveTotal
        availabelLeavesLabel.text = initialAPIDataVar?.leaveAvailable
        takenLeavesLabel.text = initialAPIDataVar?.leaveTaken
        self.leaveListData = initialAPIDataVar?.leaveListData ?? []
        DispatchQueue.main.async {
            self.leaveReuestsTableView.reloadData()
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaveListData.count
        //return DataService.instance.getLeaveRequests().count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leaveData = leaveListData[indexPath.row]
        
        if leaveData.inProcess == 0 {
            let cell = self.leaveReuestsTableView.dequeueReusableCell(withIdentifier: "appliedRequestTableViewCell", for: indexPath) as! appliedRequestTableViewCell
            cell.updateViews(leaveReuests: leaveData)
            cell.delegate = self
            return cell
        } else {
            let cell = self.leaveReuestsTableView.dequeueReusableCell(withIdentifier: "reviewedTableViewCell", for: indexPath) as! reviewedTableViewCell
            cell.updateViews(leaveReuests: leaveData)
            return cell
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        initialLeaveDataFromAPI()
    }
    
    @IBAction func applyLeaveTapped(_ sender: Any) {
        let overLayer = leaveApplicationPopUPViewController()
        overLayer.popUp(sender: self)
    }
    
    func deleteBtnPressed(forCell cell: appliedRequestTableViewCell) {
        initialLeaveDataFromAPI()
    }
    
}
