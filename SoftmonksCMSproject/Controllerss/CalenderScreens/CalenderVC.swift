//
//  CalenderVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 03/07/24.
//

import UIKit
import Alamofire

class CalenderVC: UIViewController, LogoDisplayable {
    var selectedDate = Date()
    var totalSquares: [DayInfo] = []
    var monthInfoVar: CalendarDataResponse?
    var currentMonthVar: String?
    var currentYearVar: String?
    var todaysDetails: TodaysEvent?
    var eventsForToday: [Event] = []
    
//    var dayInfoVar: [DayInfo] = []
    
    @IBOutlet weak var iDiscriptionViewExpandButton: UIButton!
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var weekDayStackView: UIStackView!
    @IBOutlet weak var todayDateTextLabel: UILabel!
    @IBOutlet weak var bottomEventsView: UIView!
    @IBOutlet weak var todaysEventsCollectionView: UICollectionView!
    @IBOutlet weak var todayTextLabel: UILabel!
    @IBOutlet weak var dateForTodayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calender"
        addLogoToFooter()
//        setCellView()
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        todaysEventsCollectionView.dataSource = self
        todaysEventsCollectionView.delegate = self
        monthCollectionView.register(DateCollectionViewCell.nib(), forCellWithReuseIdentifier: "DateCollectionViewCell")
        todaysEventsCollectionView.register(calendarEmojiCell.nib(), forCellWithReuseIdentifier: "calendarEmojiCell")
        bottomEventsView.onlyCornerRadius(conRadius: 5.0)
        bottomEventsView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 0.0, height: 0.0), radius: 3.0)
        intialAPICall()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCellView()
        setTodayEventsCellView()
    }
    
    func intialAPICall() {
        (currentMonthVar, currentYearVar) = CalenderHelper().getCurrentMonthAndYear()
        monthDataAPIcall(monthString: currentMonthVar!, yearString: currentYearVar!)
    }
    
    func setCellView() {
        let flowLayoutForMonthGrid = monthCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = (monthCollectionView.frame.size.width - 2) / 8
        let cellHeight = (monthCollectionView.frame.size.height - 2) / 7
        flowLayoutForMonthGrid.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayoutForMonthGrid.minimumInteritemSpacing = 2
        flowLayoutForMonthGrid.minimumLineSpacing = 2
        
        for case let view in weekDayStackView.arrangedSubviews {
            view.layer.cornerRadius = 2.5
            view.clipsToBounds = true
        }
    }

    
    @IBAction func toggleEmojiDescriptionViewButtonTapped(_ sender: UIButton) {
        let emojiInfo = EmojiDiscriptionPopUpVC()
        emojiInfo.presentationContext = .forEmojiDiscription
        self.present(emojiInfo, animated: true)
    }
    
    @IBAction func tappedPreviouMonthButton(_ sender: Any) {
        var (previousMonth, previousYear) = CalenderHelper().getNewMonthAndYear(currentMonth: currentMonthVar!, currentYear: currentYearVar!, actionFlag: 0)
        currentMonthVar = previousMonth
        currentYearVar = previousYear
        monthDataAPIcall(monthString: previousMonth, yearString: previousYear)

    }
    
    @IBAction func tappedNeextMonthButton(_ sender: Any) {
        var (nextMonth, nextYear) = CalenderHelper().getNewMonthAndYear(currentMonth: currentMonthVar!, currentYear: currentYearVar!, actionFlag: 1)
        currentMonthVar = nextMonth
        currentYearVar = nextYear
        monthDataAPIcall(monthString: nextMonth, yearString: nextYear)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func monthDataAPIcall(monthString: String, yearString: String) {
        let perameterList: [String: Any] = ["mode":"calenderData", "month": monthString, "year": yearString]
        AF.request(apiURL, method: .post, parameters: perameterList, encoding: URLEncoding.default)
            .responseDecodable(of: CalendarDataResponse.self) { response in
                switch response.result {
                case .success(let ResponseData):
//                    print(ResponseData)
                    self.monthInfoVar = ResponseData
                    self.totalSquares = ResponseData.monthArr!
                    self.monthAndYearLabel.text = ResponseData.currentMonth
                    self.dateForTodayLabel.text = ResponseData.eventData?.todayDate
//                    self.todaysDetails = ResponseData.todaysEvent
                    if let eventsForToday = ResponseData.eventData?.events {
                        self.eventsForToday = eventsForToday
                    }
                    
                    DispatchQueue.main.async {
                        self.monthCollectionView.reloadData()
                        self.todaysEventsCollectionView.reloadData()
                    }
                case .failure(let Responseerror):
                    self.showAlert(title: "Erorr", message: "\(Responseerror)")
                }
            }
    }
    
    func showDayDetails(selectedDate: String) {
        print(selectedDate)
        let perameters: [String:Any] = [ "mode":"calenderPopUp", "searchDate":selectedDate]
        AF.request(apiURL, method: .post, parameters: perameters, encoding: URLEncoding.default)
            .responseDecodable(of: CalendarDataResponse.self) {  response in
                switch response.result {
                case .success(let dayInfo):
                    if dayInfo.err == 0 {
                        print(dayInfo)
                        if (dayInfo.eventData?.events.count)! <= 0 {
                            self.showAlert(title: "No Events", message: "Nothing To Note On This Day")
                        } else {
                            let popUpVC = EmojiDiscriptionPopUpVC()
                            popUpVC.presentationContext = .forInformationAboutDay
                            popUpVC.eventDataVar = dayInfo.eventData
                            self.present(popUpVC, animated: true)
                        }

                    } else {
                        self.showAlert(title: "Wrong Data", message: "Response Recevied is not expected Response")
                    }
                case .failure(let error):
                    self.showAlert(title: "Erorr", message: "\(error)")
                }
        }
    }
    
    func presentDayPopup() {
        
    }
    
    func setTodayEventsCellView() {
        guard let todayEventsFlowLayout = todaysEventsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let padding: CGFloat = 2.0
        let itemsPerRow: CGFloat = 2
        let lineSpacing: CGFloat = 10.0
        
        let totalPadding = padding * (itemsPerRow - 1)
        let collectionViewWidth = todaysEventsCollectionView.frame.size.width
        let availableWidth = collectionViewWidth - totalPadding
        
        let cellWidth = availableWidth / itemsPerRow
        let cellHeight: CGFloat = 30 // Set your desired height here
        
        todayEventsFlowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        todayEventsFlowLayout.minimumInteritemSpacing = padding
        todayEventsFlowLayout.minimumLineSpacing = lineSpacing // Add spacing between rows
        todayEventsFlowLayout.sectionInset = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
    }
}

extension CalenderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case monthCollectionView :
            return totalSquares.count
        case todaysEventsCollectionView:
            return eventsForToday.count
        default : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case monthCollectionView:
            let dateCell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
            let dateString = totalSquares[indexPath.item]
            if let monthInfoVar = monthInfoVar {
                dateCell.configureCell(monthdataInfo: monthInfoVar, dayInfo: totalSquares[indexPath.item])
            } else {
                self.showAlert(title: "Error", message: "Month Information ins Empty")
            }
            return dateCell
            
        case todaysEventsCollectionView:
            let eventCell = todaysEventsCollectionView.dequeueReusableCell(withReuseIdentifier: "calendarEmojiCell", for: indexPath) as! calendarEmojiCell
            eventCell.todayEventCellonfigure(with: eventsForToday[indexPath.item])
            return eventCell
        default:
            let defaultDateCell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
            return defaultDateCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == monthCollectionView {
            if let dateString = totalSquares[indexPath.item].date {
                self.showDayDetails(selectedDate: dateString)
            }
        }
    }
}
