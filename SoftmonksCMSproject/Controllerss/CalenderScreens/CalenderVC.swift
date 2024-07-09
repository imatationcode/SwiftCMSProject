//
//  CalenderVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 03/07/24.
//

import UIKit

class CalenderVC: UIViewController, LogoDisplayable {
    var selectedDate = Date()
    var totalSquares = [String]()
    var todayEventList = [
        EmojiNameAndImage(title: "Birthday", EmojiImage: "BirthdayCakeIcon"),
        EmojiNameAndImage(title: "Holiday", EmojiImage: "HolidayIcon"),
        EmojiNameAndImage(title: "Birthday", EmojiImage: "BirthdayCakeIcon"),
        EmojiNameAndImage(title: "Holiday", EmojiImage: "HolidayIcon"),
        EmojiNameAndImage(title: "Birthday", EmojiImage: "BirthdayCakeIcon"),
        EmojiNameAndImage(title: "Holiday", EmojiImage: "HolidayIcon"),
        EmojiNameAndImage(title: "Birthday", EmojiImage: "BirthdayCakeIcon"),
        EmojiNameAndImage(title: "Holiday", EmojiImage: "HolidayIcon")
        ]

    @IBOutlet weak var iDiscriptionViewExpandButton: UIButton!
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var weekDayStackView: UIStackView!
    @IBOutlet weak var todayDateTextLabel: UILabel!
    @IBOutlet weak var bottomEventsView: UIView!
    @IBOutlet weak var todaysEventsCollectionView: UICollectionView!
    
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
        setUpMonthViewGrid()
        bottomEventsView.onlyCornerRadius(conRadius: 5.0)
        bottomEventsView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 0.0, height: 0.0), radius: 3.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCellView()
        setTodayEventsCellView()
    }
    
    func setCellView() {
        let flowLayoutForMonthGrid = monthCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = (monthCollectionView.frame.size.width - 2) / 8
        let cellHeight = (monthCollectionView.frame.size.height - 2) / 7
        flowLayoutForMonthGrid.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayoutForMonthGrid.minimumInteritemSpacing = 2
        flowLayoutForMonthGrid.minimumLineSpacing = 2
        
        for case let view as UIView in weekDayStackView.arrangedSubviews {
            view.layer.cornerRadius = 2.5
            view.clipsToBounds = true
        }
    }

    
    @IBAction func toggleEmojiDescriptionViewButtonTapped(_ sender: UIButton) {
        let emojiInfo = EmojiDiscriptionPopUpVC()
        self.present(emojiInfo, animated: true)
        
//        UIView.animate(withDuration: 0.4, animations: {
//            self.emojiDescriptionView.isHidden.toggle()
//        })
    }
    
    @IBAction func tappedPreviouMonthButton(_ sender: Any) {
        selectedDate = CalenderHelper().minusMonth(date: selectedDate)
        setUpMonthViewGrid()
    }
    
    @IBAction func tappedNeextMonthButton(_ sender: Any) {
        selectedDate = CalenderHelper().plusMonth(date: selectedDate)
        setUpMonthViewGrid()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    func setTodayEventsCellView() {
        guard let todayEventsFlowLayout = todaysEventsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let padding: CGFloat = 2.0
        let itemsPerRow: CGFloat = 2
        let lineSpacing: CGFloat = 10.0 // Adjust this value to set the spacing between rows
        
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
    
    func setUpMonthViewGrid() {
        totalSquares.removeAll()
        let calc = CalenderHelper()
        let daysInMonth = calc.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calc.firstOfMonth(date: selectedDate)
        let startingSpaces = calc.weekDay(date: firstDayOfMonth) - 1
        
        var count: Int = 1
        
        while (count <= 42) {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        monthAndYearLabel.text = CalenderHelper().monthString(date: selectedDate) + " " + CalenderHelper().yearString(date: selectedDate)
        monthCollectionView.reloadData()
    }
    
    func isCurrentDate(_ dateString: String) -> Bool {
        guard let day = Int(dateString), day != 0 else {
            return false
        }
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        return todayComponents.year == selectedComponents.year &&
               todayComponents.month == selectedComponents.month &&
               todayComponents.day == day
    }
}

extension CalenderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case monthCollectionView :
            return totalSquares.count
        case todaysEventsCollectionView:
            return todayEventList.count
        default : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case monthCollectionView:
            let dateCell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
            let dateString = totalSquares[indexPath.item]
            dateCell.configureCell(dateString: dateString, isCurrentDateCell: isCurrentDate(dateString))
            return dateCell
            
        case todaysEventsCollectionView:
            let eventCell = todaysEventsCollectionView.dequeueReusableCell(withReuseIdentifier: "calendarEmojiCell", for: indexPath) as! calendarEmojiCell
            eventCell.configureCell(with: todayEventList[indexPath.item])
            return eventCell
        default:
            let defaultDateCell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
            let dateString = totalSquares[indexPath.item]
            defaultDateCell.configureCell(dateString: dateString, isCurrentDateCell: isCurrentDate(dateString))
            return defaultDateCell
        }
    }
}
