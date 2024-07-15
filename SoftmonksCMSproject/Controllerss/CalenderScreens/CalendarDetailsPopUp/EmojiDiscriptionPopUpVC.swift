//
//  EmojiDiscriptionVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 05/07/24.
//

import UIKit

class EmojiDiscriptionPopUpVC: UIViewController {
    enum PresentationContext {
        case forEmojiDiscription
        case forInformationAboutDay
    }
    var eventDataVar: TodaysEvent?
    var presentationContext: PresentationContext = .forInformationAboutDay
    
    static let controllerIdentifier = "EmojiDiscriptionVC"
    let emojiTitleAndIconArray: [EmojiNameAndImage] = [
        EmojiNameAndImage(title: "Birthday", EmojiImage: "BirthdayCakeIcon"),
        EmojiNameAndImage(title: "Holiday", EmojiImage: "HolidayIcon"),
        EmojiNameAndImage(title: "Applied Full Day Leave", EmojiImage: "AppliedFullIcon"),
        EmojiNameAndImage(title: "Approved Full Day Leave", EmojiImage: "ApprovedFullIcon"),
        EmojiNameAndImage(title: "Applied Morning Half Day Leave", EmojiImage: "AppliedMHIcon"),
        EmojiNameAndImage(title: "Approved Morning Half Day Leave", EmojiImage: "ApprovedMHIcon"),
        EmojiNameAndImage(title: "Applied Evening Half Day Leave", EmojiImage: "AppliedEHIcon"),
        EmojiNameAndImage(title: "Approved Evening Half Day Leave", EmojiImage: "ApprovedEHIcon"),
        EmojiNameAndImage(title: "Urgent Task", EmojiImage: "UrgentIcon"),
        EmojiNameAndImage(title: "High Priority Task", EmojiImage: "PriorityIcon"),
        EmojiNameAndImage(title: "Weekly Meeting", EmojiImage: "GroupMeetIcon")
    ]
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emojiCollectionVIew: UICollectionView!
    @IBOutlet weak var dateValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiCollectionVIew.dataSource = self
        emojiCollectionVIew.delegate = self
        emojiCollectionVIew.register(calendarEmojiCell.nib(), forCellWithReuseIdentifier: "calendarEmojiCell")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popUpDismiss))
        outterView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initalViewDesign()
    }
    
    init() {
        super.init(nibName: EmojiDiscriptionPopUpVC.controllerIdentifier, bundle: Bundle(for: EmojiDiscriptionPopUpVC.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func popUpDismiss() {
        self.dismiss(animated: true)
    }
    
    func initalViewDesign() {
        contentView.layer.cornerRadius = 4.0
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        switch presentationContext {
        case .forInformationAboutDay:
            dateValueLabel.text = eventDataVar?.searchDate
            dateValueLabel.isHidden = false
        case .forEmojiDiscription:
            dateValueLabel.isHidden = true
        }
    }
}

extension EmojiDiscriptionPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch presentationContext.self {
        case .forEmojiDiscription:
           return emojiTitleAndIconArray.count
        case .forInformationAboutDay:
            return (eventDataVar?.events.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch presentationContext.self {
        case .forEmojiDiscription:
            let collectionViewCell = emojiCollectionVIew.dequeueReusableCell(withReuseIdentifier: "calendarEmojiCell", for: indexPath) as! calendarEmojiCell
            let cellData = emojiTitleAndIconArray[indexPath.item]
            collectionViewCell.descriptionConfigureCell(with: cellData)
            return collectionViewCell
        case .forInformationAboutDay:
            let dayCell = emojiCollectionVIew.dequeueReusableCell(withReuseIdentifier: "calendarEmojiCell", for: indexPath) as! calendarEmojiCell
            let cellData = eventDataVar?.events[indexPath.item]
            dayCell.todayEventCellonfigure(with: cellData!)
            return dayCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 2.0
        let itemsPerRow: CGFloat = 2
        let totalPadding = padding * (itemsPerRow - 1)
        let collectionViewWidth = collectionView.frame.size.width
        let availableWidth = collectionViewWidth - totalPadding
        let cellWidth = availableWidth / itemsPerRow
        let cellHeight: CGFloat = 30 // Set your desired height here
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }
}
