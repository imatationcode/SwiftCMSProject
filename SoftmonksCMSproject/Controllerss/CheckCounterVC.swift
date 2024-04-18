//
//  CheckCounterVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 22/02/24.
//

import UIKit
import Alamofire

struct keysStruct {
    let checkInOutStatusKey = "MainButtonStatus"
    let rotationAnleKey = "rotationAngleStatus"
    let takeBreakKey = "takeBreakStatus"
}


class CheckCounterVC: UIViewController,LogoDisplayable {
    var istakebreakeTaped : Bool = false
    var isrotated = false
    var isCheckinoutBtnClicked = false
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var InitailCheckCounterDataVar : checkCounterModel?
    
    @IBOutlet weak var checkArrowImage: UIImageView!
    @IBOutlet weak var mainButtonView: UIControl!
    @IBOutlet weak var empDesignationLabel: UILabel!
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var tapToCheckInLabel: UILabel!
    @IBOutlet weak var timerViewBottom: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var takeBreakButton: UIButton!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var employeeName: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Check Counter"
        initialAPICall()
       // initialState()
      //  checkInOutBtn.addTarget(self, action: #selector(checkInOutBtnTapped), for: .touchUpInside)
        employeeName.text = userDict?["name"] as? String
        empDesignationLabel.text = userDict?["designation"] as? String
        
        addLogoToFooter()
        updateTimeDate()
        isCheckinoutBtnClicked = UserDefaults.standard.bool(forKey: keysStruct().checkInOutStatusKey)
        isrotated = UserDefaults.standard.bool(forKey: keysStruct().rotationAnleKey)
        istakebreakeTaped = UserDefaults.standard.bool(forKey: keysStruct().takeBreakKey)
        updateButtonState()
        intialStatus()

    }
    
    @IBAction func takeBreakeBtnTapped(_ sender: Any) {
        istakebreakeTaped.toggle()
        UserDefaults.standard.set(istakebreakeTaped, forKey: keysStruct().takeBreakKey)
        updateButtonVisibility()
    }
    
    @IBAction func resumeBtnTapped(_ sender: Any) {
        istakebreakeTaped.toggle()
        UserDefaults.standard.set(istakebreakeTaped, forKey: keysStruct().takeBreakKey)
        updateButtonVisibility()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //bottomview
        timerViewBottom.applyCornerRadiusAndBorder(radius: 0.5, borderWidth: 0.5, borderColor:"E5E5E5", shadowRadius: 2, shadowOpacity: 0.5, shadowColor: "000000" , shadowOffset: CGSize(width: 0, height: 2))
    }
    
    func initialAPICall() {
      //  print(userDict?["id"])
        let parameters = ["mode":"initClock", "id" : userDict?["id"] ?? ""] as [String : Any]
        AF.request(apiURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
                    .responseDecodable(of: checkCounterModel.self) { [weak self] response in  // Move switch statement closer
                        guard let self = self else { return }
                        switch response.result {
                        case .success(let initailCheckCounterData):
                            self.InitailCheckCounterDataVar = initailCheckCounterData
                            print(initailCheckCounterData)
                            // Handle successful login data retrieval
                            guard initailCheckCounterData.err == 0 else {
                                self.showAlert(title: "Login Failed", message: initailCheckCounterData.errMsg ?? "")
                                print(initailCheckCounterData.errMsg ?? "Request failed")  //  debugging purposes
                                return
                            }  //  debugging purpose
                        case .failure(let error):
                            print(error)
                            self.showAlert(title: "Login Error", message: "Please Re-Check Your Email and Password")
                        }
                    }
            }
    //func to convert degree in to radians
    func convertDegreeRadians(degrees: CGFloat) -> CGFloat{
        return degrees / 180.0 * CGFloat.pi
    }
    
   
    func intialStatus(){
        if (!isCheckinoutBtnClicked){
            takeBreakButton.isHidden = true
            resumeBtn.isHidden = true
        }
    }
    @IBAction func mainCheckButtonTapped(_ sender: Any) {
        tapToCheckInLabel.text = isCheckinoutBtnClicked ? "TAP TO CHECK IN" : "TAP TO CHECK OUT"
        isCheckinoutBtnClicked.toggle()
        isrotated.toggle()
        //        let btnRotationAngle: Double = isrotated ? 180.0 : 0.0
        //        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState]) {
        //                self.checkInOutBtn.transform = CGAffineTransform(rotationAngle: btnRotationAngle)
        //            }
                
                if isCheckinoutBtnClicked {
                    rotateButtonTo180()
                } else {
                    reverseButtonRotation()
                }
                
                UserDefaults.standard.set(isCheckinoutBtnClicked, forKey: keysStruct().checkInOutStatusKey)
                UserDefaults.standard.set(isrotated, forKey: keysStruct().rotationAnleKey)
               // updateButtonState()
                if (!isCheckinoutBtnClicked){
                    takeBreakButton.isHidden = true
                    resumeBtn.isHidden = true
                    istakebreakeTaped = true
                    UserDefaults.standard.set(istakebreakeTaped, forKey: keysStruct().takeBreakKey)
                } else {
                    resumeBtn.isHidden = true
                    takeBreakButton.isHidden = false
                  }
        
    }
    
    func reverseButtonRotation() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
              self.checkArrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(360.0) * .pi / 180.0)
          }
           }
    
    func rotateButtonTo180() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.checkArrowImage.transform = CGAffineTransform(rotationAngle: -CGFloat(180.0) * .pi / 180.0)
        }
    }
    
    func updateButtonState() {
        let btnRotationAngle: Double = isrotated ? 180.0 : 360.0
        checkArrowImage.transform = CGAffineTransform(rotationAngle: convertDegreeRadians(degrees: CGFloat(btnRotationAngle)))
        tapToCheckInLabel.text = isCheckinoutBtnClicked ? "TAP TO CHECK OUT" : "TAP TO CHECK IN"
        takeBreakButton.isHidden = !istakebreakeTaped
        resumeBtn.isHidden = istakebreakeTaped
    }

    func updateButtonVisibility() {
        // Hide or show buttons based on the state
        takeBreakButton.isHidden = !istakebreakeTaped
        resumeBtn.isHidden = istakebreakeTaped
    }
    
    
    func updateTime() {
            // Update the timeLabel with the current time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm"
            let timeString = dateFormatter.string(from: Date())
            timeLabel.text = timeString

            // Update the timePeriod label (AM/PM)
            dateFormatter.dateFormat = "a"
            let amPmString = dateFormatter.string(from: Date())
        timePeriodLabel.text = amPmString
        }
    
    func updateDate(){
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        let currentDate = Date()
        let currentDateString = dateFormatter.string(from: currentDate)
        dateLabel.text = currentDateString
    }
    func updateTimeDate(){
        updateTime()
        updateDate()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ (_) in self.updateTime() }
        
    }
    
   
   

}
