//
//  PersonalDetailsVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit

class PersonalDetailsVC: UIViewController, LogoDisplayable {
    let imgSelectedColor = UIColor(hex: "00369A")
    let unselectedColor = UIColor.gray
    let textSelectedColor = UIColor.black
    
    var changePasswordVC: ChangePasswordVC?
    var popUpPasswordVarification: PasswordVarificationPopUpVC?
    var varificationPopVar: PasswordVarificationPopUpVC?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var KeyImage: UIImageView!
    
    @IBOutlet weak var homeTextLable: UILabel!
    @IBOutlet weak var documentTextLabel: UILabel!
    @IBOutlet weak var designationTextLabel: UILabel!
    @IBOutlet weak var passwordTextLabel: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Personal details"
        addLogoToFooter()
        designTabBar()
        DispatchQueue.main.async {
            self.loadProfile()
            self.updateTabBarImages(selectedIndex: 0)
        }
        
    }
    
    func loadProfile() {
        title = "Your Profile"
        let profileVC = YourProfileVC(nibName: "YourProfileVC", bundle: nil)
        addChild(profileVC)
        contentView.addSubview(profileVC.view)
        profileVC.view.frame = contentView.bounds
        profileVC.didMove(toParent: self)
    }
    
    func designTabBar() {
        tabBarView.layer.cornerRadius = tabBarView.frame.size.height / 2.2
        tabBarView.layer.borderWidth = 0.6
        tabBarView.layer.borderColor = UIColor.lightGray.cgColor
        tabBarView.layer.shadowColor = UIColor.darkGray.cgColor
        tabBarView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        tabBarView.layer.shadowRadius = 6
        tabBarView.layer.shadowOpacity = 0.5
    }
    
    @IBAction func tabBarButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            loadProfile()
        case 2:
            title = "Documents"
            let docVC = DocumentsVC(nibName: "DocumentsVC", bundle: nil)
            addChild(docVC)
            contentView.addSubview(docVC.view)
            docVC.view.frame = contentView.bounds
            docVC.didMove(toParent: self)
        case 3:
            title = "Designation"
            let designVC = DesignationVC(nibName: "DesignationVC", bundle: nil)
            addChild(designVC)
            contentView.addSubview(designVC.view)
            designVC.view.frame = contentView.bounds
            designVC.didMove(toParent: self)
        case 4:
            title = "Change Password"
            let changePassVC = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
            changePassVC.changePassdelegateVar = self 
            addChild(changePassVC)
            contentView.addSubview(changePassVC.view)
            changePassVC.view.frame = contentView.bounds
            changePassVC.didMove(toParent: self)
            self.changePasswordVC = changePassVC
            
            let popupVC = PasswordVarificationPopUpVC()
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overCurrentContext
            present(popupVC, animated: true, completion: nil)
            self.popUpPasswordVarification = popupVC
            
        default:
            print("TabBarError")
        }
        updateTabBarImages(selectedIndex: tag - 1)
    }
    
    func updateTabBarImages(selectedIndex: Int) {
        let tabImageViews = [profileImage, documentImage, flagImage, KeyImage]
        let tabTextLabels = [homeTextLable, documentTextLabel, designationTextLabel, passwordTextLabel]
        
        for (index, imageView) in tabImageViews.enumerated() {
            if index == selectedIndex {
                imageView?.tintColor = imgSelectedColor
                print("poping Image")
                popAnimate(view: imageView)
            } else {
                imageView?.tintColor = unselectedColor
            }
        }
        
        for (index, selectLabel) in tabTextLabels.enumerated() {
            if index == selectedIndex {
                selectLabel?.textColor = textSelectedColor
                print("popint Label")
                popAnimate(view: selectLabel)
            } else {
                selectLabel?.textColor = unselectedColor
//                selectLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            }
        }

    }
    
    func popAnimate(view: UIView?) {
        
        guard let view = view else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform.identity
            }
        }
    }
    
    func logOut() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "homeNavigationViewController") as? homeNavigationViewController {
            vc.modalPresentationStyle = .fullScreen
            UserDefaults.standard.removeObject(forKey: "isLoggedIN")
            UserDefaults.standard.removeObject(forKey: "UserDetails")
            self.present(vc, animated: true)
            
        }
        
    }
    
}// END of VC class

extension PersonalDetailsVC: PasswordVarificationPopUpVCDelegate, changePassDelegate {
    func loggingOut() {
        logOut()
    }
    func dismissPopUp() {
        updateTabBarImages(selectedIndex: 0)
        loadProfile()
    }
    
    
}
