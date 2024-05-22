//
//  ProfileMenuVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 19/02/24.
//

import UIKit
import Alamofire

class ProfileMenuVC: UIViewController, LogoDisplayable, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    let myId: String = UserDefaults.standard.object(forKey: "isLoggedIN") as! String
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var optionImg: [String] = ["personIcon", "calendarSVGIcon", "OnTimeIcon", "LeaveOfficeIcon", "SalaryIcon", "ClipboardIcon"]
    var optionNames: [String] = ["Profile", "Calendar", "Check Counter", "Leave Requests", "Salary Details", "Company Policies"]
    
    @IBOutlet weak var empDesignationLabel: UILabel!
    @IBOutlet weak var employeNameLabel: UILabel!
    @IBOutlet weak var menuListCollectionView: UICollectionView!
    @IBOutlet weak var designationBackgrdView: UIView!
    @IBOutlet weak var potraitImg: UIImageView!

    override func viewDidLoad() {
       // print("In MainMenu")
        navigationItem.hidesBackButton = true
        super.viewDidLoad()
        addLogoToFooter()
        menuListCollectionView.dataSource = self
        menuListCollectionView.delegate = self
        employeNameLabel.text = userDict?["name"] as? String
        empDesignationLabel.text = userDict?["designation"] as? String
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mycell = menuListCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! CollectionViewCell
        mycell.optionImg.image = UIImage(named: optionImg[indexPath.row])
        mycell.optionTitle.text = optionNames[indexPath.row]
        return mycell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         // Determine which cell was tapped based on indexPath
         switch indexPath.item {
         case 0:
             profileTapped()
         case 1:
             calendarTapped()
         case 2:
             checkCounterTapped()
         case 3:
             leaveRequestTapped()
         case 4:
             salaryTapped()
         case 5:
             companyPoliciesTapped()
         default:
             break
         }
     }

     func profileTapped() {
        print("Profile tapped")
         if let personalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonalDetailsVC") as? PersonalDetailsVC{
             navigationController?.pushViewController(personalVC, animated: true)
         }
     }

     func calendarTapped() {
         print("Calendar tapped")
     }

     func checkCounterTapped() {
         if let checkcounterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckCounterVC") as? CheckCounterVC{
             navigationController?.pushViewController(checkcounterVC, animated: true)
         }
     }

     func leaveRequestTapped() {
         print("Leave Request tapped")
         
         if let leaveReqsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeaveRequestVC") as? LeaveRequestVC{
             navigationController?.pushViewController(leaveReqsVC, animated: true)
         }
     }
     func salaryTapped() {
         
         print("Salary Details tapped")
     }

     func companyPoliciesTapped() {
         
         print("Company Policies tapped")
     }

    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = .identity
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyImageStyling()
        
        designationBackgrdView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        designationBackgrdView.applyGradient(colors: ["00359A", "95CCFF"], angle: -180.0,conRads: 8.0)
        
        let nibCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.menuListCollectionView.register(nibCell,forCellWithReuseIdentifier: "cell")
        
        menuListCollectionView.delegate = self
        menuListCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        //resizing cell
        let listViewWidth = menuListCollectionView.frame.width
        let aspectRatio: CGFloat = 1.65
        let itemWidth = ((listViewWidth  / 2) - 30)
        let itemHeight = itemWidth / aspectRatio
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = itemHeight * 0.16
        menuListCollectionView.collectionViewLayout = layout
        menuListCollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //Converting Profile image to Circular Shape and adding blueborder
    private func applyImageStyling() {
        potraitImg.layer.cornerRadius = min(potraitImg.frame.size.width, potraitImg.frame.size.height) / 2
        potraitImg.layer.masksToBounds = true
        // Adding Border
        potraitImg.layer.borderWidth = 2
        potraitImg.layer.borderColor = UIColor(red: 0.2, green: 0.6196, blue: 1.0, alpha: 1.0).cgColor

    }
    
    @IBAction func tappedOnLogout(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "homeNavigationViewController") as! homeNavigationViewController
        if let sd =  self.view.window?.windowScene?.delegate as? SceneDelegate , let window = sd.window {
            //self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            UserDefaults.standard.removeObject(forKey: "isLoggedIN")
            UserDefaults.standard.removeObject(forKey: "UserDetails")
            self.present(vc, animated: true)
            
        }
       
    }
}
