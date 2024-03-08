//
//  CheckCounterVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 22/02/24.
//

import UIKit

class CheckCounterVC: UIViewController,LogoDisplayable {

    @IBOutlet weak var checkInOutBtn: UIButton!
    var isCheckinoutBtnClicked = false
    var istakebreakeTaped = false
    var isrotated = false
    struct keysStruct {
        let checkInOutStatusKey = "MainButtonStatus"
        let rotationAnleKey = "rotationAngleStatus"
        let takeBreakKey = "takeBreakStatus"
    }

    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var tapToCheckInLabel: UILabel!
    @IBOutlet weak var timerViewBottom: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var takeBreakButton: UIButton!
    @IBOutlet weak var timePeriodLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleFont = UIFont.systemFont(ofSize: 20.0) // Set font size
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
        self.title = "Check Counter"
       // initialState()
        checkInOutBtn.addTarget(self, action: #selector(checkInOutBtnTapped), for: .touchUpInside)
        
       // headerTitle.titlelabel.text = "Check Counter"
        addLogoToFooter()
        updateTimeDate()
        isCheckinoutBtnClicked = UserDefaults.standard.bool(forKey: keysStruct().checkInOutStatusKey)
        isrotated = UserDefaults.standard.bool(forKey: keysStruct().rotationAnleKey)
        istakebreakeTaped = UserDefaults.standard.bool(forKey: keysStruct().takeBreakKey)
        updateButtonState()
        intialStatus()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //bottomview
        timerViewBottom.applyCornerRadiusAndBorder(radius: 0.5, borderWidth: 0.5, borderColor:"E5E5E5", shadowRadius: 2, shadowOpacity: 0.5, shadowColor: "000000" , shadowOffset: CGSize(width: 0, height: 2))
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
    @IBAction func checkInOutBtnTapped(_ sender: Any) {
        tapToCheckInLabel.text = isCheckinoutBtnClicked ? "TAP TO CHECK IN" : "TAP TO CHECK OUT"
        isCheckinoutBtnClicked.toggle()
        isrotated.toggle()
        let btnRotationAngle: Double = isrotated ? 180.0 : 0.0
        checkInOutBtn.transform = CGAffineTransform(rotationAngle: convertDegreeRadians(degrees: CGFloat(btnRotationAngle)))
        UserDefaults.standard.set(isCheckinoutBtnClicked, forKey: keysStruct().checkInOutStatusKey)
        UserDefaults.standard.set(isrotated, forKey: keysStruct().rotationAnleKey)
        updateButtonState()
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
    
    func updateButtonState() {
        let btnRotationAngle: Double = isrotated ? 180.0 : 0.0
        checkInOutBtn.transform = CGAffineTransform(rotationAngle: convertDegreeRadians(degrees: CGFloat(btnRotationAngle)))
        tapToCheckInLabel.text = isCheckinoutBtnClicked ? "TAP TO CHECK OUT" : "TAP TO CHECK IN"
        takeBreakButton.isHidden = !istakebreakeTaped
        resumeBtn.isHidden = istakebreakeTaped
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
