//
//  LeaveRequestVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 01/03/24.
//

import UIKit

class LeaveRequestVC: UIViewController, LogoDisplayable, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var leaveReuestsTableView: UITableView!
    var list = [1,2,3,4,5,6,7,8,9,10]
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Leave Requests"
        addLogoToFooter()
        self.leaveReuestsTableView.delegate = self
        self.leaveReuestsTableView.dataSource = self
//        self.leaveReuestsTableView.rowHeight = UITableView.automaticDimension
//        self.leaveReuestsTableView.estimatedRowHeight = 144.0
      //  self.leaveReuestsTableView.register(UINib(nibName: "InProcessTableViewCell", bundle: nil), forCellReuseIdentifier: "inProcessCell")
        self.leaveReuestsTableView.register(UINib(nibName: "appliedRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "appliedRequestTableViewCell")
        self.leaveReuestsTableView.register(UINib(nibName: "reviewedTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewedTableViewCell")
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.getLeaveRequests().count
        //return self.list.count
    }
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.leaveReuestsTableView.dequeueReusableCell(withIdentifier: "appliedRequestTableViewCell") as? appliedRequestTableViewCell)!
        let leaveReq = DataService.instance.getLeaveRequests()[indexPath.row]
        cell.updateViews(leaveReuests: leaveReq)
        return cell
//
        //Finall cell after the request has been reviewed
//        let fCell = (self.leaveReuestsTableView.dequeueReusableCell(withIdentifier: "reviewedTableViewCell") as? reviewedTableViewCell)!
//        let leaveReq = DataService.instance.getLeaveRequests()[indexPath.row]
//        fCell.updateViews(leaveReuests: leaveReq)
//        return fCell
        
    }

    @IBAction func applyLeaveTapped(_ sender: Any) {
        let overLayer = leaveApplicationPopUPViewController()
        overLayer.popUp(sender: self)
    }
}
