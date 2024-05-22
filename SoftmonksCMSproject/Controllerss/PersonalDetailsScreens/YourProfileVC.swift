//
//  YourPorofileVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit
import Alamofire

class YourProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var userProfileData: PersonalDetialsResponse?
    var detailsList: [UserDetail] = []
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    
    @IBOutlet weak var staffCodeLabel: UILabel!
    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageView.applyGradient(colors: ["00359A", "95CCFF"], angle: -180.0,conRads: 0.0)
        profileImage.layer.cornerRadius = profileImage.bounds.size.height / 2
        mainImageView.layer.cornerRadius = mainImageView.bounds.size.height / 2
        mainImageView.layer.masksToBounds = true
        self.detailsTableView.register(UINib(nibName: "PersonalDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalDetailsTableViewCell")
        self.detailsTableView.delegate = self
        self.detailsTableView.dataSource = self
        profileDataAPICall()
//        mainImageView.mainIconImage.image = UIImage(named: "passportImg")
        
        
    }
    
    func profileDataAPICall(){
        let paramenters: [String : Any] = ["mode": "getUserData", "id": userDict?["id"] ?? "" ]
        AF.request(apiURL, method: .post, parameters: paramenters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: PersonalDetialsResponse.self){ [weak self] response in
                guard let self = self else{ return }
                switch response.result {
                case .success(let response):
                    print(response)
                    self.userProfileData = response
                    self.updateUI()
                    print("Done WIth API Call")
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Error", message: "Error in API Call")
                }
            }
    }
    
   func updateUI() {
       self.staffCodeLabel.text = userProfileData?.staffCode
       self.detailsList = userProfileData?.userData ?? []
       DispatchQueue.main.async {
           self.detailsTableView.reloadData()
       }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let profileDtat = detailsList[indexPath.row]
        let cell = self.detailsTableView.dequeueReusableCell(withIdentifier: "PersonalDetailsTableViewCell", for: indexPath) as! PersonalDetailsTableViewCell
//        cell.viewContrroller = self
        let detailRecord = detailsList[indexPath.row]
        cell.configValues(with: detailRecord)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
 
}

