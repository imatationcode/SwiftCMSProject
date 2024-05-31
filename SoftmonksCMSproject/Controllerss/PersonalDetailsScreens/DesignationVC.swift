//
//  DesignationVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit
import Alamofire

class DesignationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var designationDatavar: DesignationsData?
    var roleList: [RoleData] = []
    
    @IBOutlet weak var mainImageView: ProfileImageCustomeView!
    @IBOutlet weak var designationsListTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageView.mainIconImage.image = UIImage(named: "ColoreDestinationFlag")
        designationsListTabelView.register(UINib(nibName: "DesignationTableViewCell", bundle: nil), forCellReuseIdentifier: "DesignationTableViewCell")
        designationsListTabelView.delegate = self
        designationsListTabelView.dataSource = self
        desingnationsAPICall()
    }
    
    func desingnationsAPICall() {
        let parameters: [String : Any] = ["mode" : "getDesignationList", "id" : userDict?["id"] ?? "" ]
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default , headers: nil)
            .responseDecodable(of: DesignationsData.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let designationResponse):
//                    print(designationResponse)
                    self.designationDatavar = designationResponse
                    self.loadTableViewData()
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Error", message: "Error in API Call")
                }
            }
    }
    
    func loadTableViewData() {
        self.roleList = designationDatavar?.userDesignationData ?? []
        self.designationsListTabelView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.designationsListTabelView.dequeueReusableCell(withIdentifier: "DesignationTableViewCell", for: indexPath) as! DesignationTableViewCell
        let detailRecord = roleList[indexPath.row]
        cell.configData(with: detailRecord)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
