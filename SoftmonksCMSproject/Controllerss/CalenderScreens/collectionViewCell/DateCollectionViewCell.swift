//
//  DateCollectionViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 05/07/24.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateDigitLabel: UILabel!
    @IBOutlet weak var dateCellBackgroundView: UIView!
    @IBOutlet weak var birthdayIcon: UIImageView!
    @IBOutlet weak var groupMeetingIcon: UIImageView!
    @IBOutlet weak var holidayIcon: UIImageView!
    @IBOutlet weak var urgentTaskIcon: UIImageView!
    @IBOutlet weak var leaveIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configureCell(monthdataInfo: CalendarDataResponse, dayInfo: DayInfo) {
        dateDigitLabel.text = dayInfo.day
//        let firstDayOfMonth = CalenderHelper().firstOfMonth(date: selectedDate)
//        let indexOfFirstDate = CalenderHelper().weekDay(date: firstDayOfMonth) - 1
//        let daysInMonth = CalenderHelper().daysInMonth(date: selectedDate)
//        let lastDayIndex = indexOfFirstDate + daysInMonth
//
        if dayInfo.isToday == 1 {
            dateCellBackgroundView.backgroundColor = .white
        } else {
            dateCellBackgroundView.backgroundColor = UIColor(hex: "E5E5E5")
        }

        if dayInfo.isMonth == 1  {
                dateDigitLabel.alpha = 1.0
                dateCellBackgroundView.alpha = 1.0
            } else {
                dateDigitLabel.alpha = 0.5
                dateCellBackgroundView.alpha = 0.4
            }
        
        dateCellBackgroundView.layer.cornerRadius = 2.5
        dateCellBackgroundView.layer.borderWidth = 0.5
        dateCellBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        birthdayIcon.isHidden = (dayInfo.birthday == 0)
        holidayIcon.isHidden = (dayInfo.holiday == 0)
        leaveIcon.isHidden = (dayInfo.leave == 0)
        urgentTaskIcon.isHidden = (dayInfo.agenda == 0)
        groupMeetingIcon.isHidden = (dayInfo.meeting == 0)
        
    }
    static func nib() -> UINib {
        return UINib(nibName: "DateCollectionViewCell", bundle: nil)
    }
}
