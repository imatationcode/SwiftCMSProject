//
//  calenderEmojiDiscriptionCollectionViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 04/07/24.
//

import UIKit

class calendarEmojiCell: UICollectionViewCell {
    static let idetenfier = "calendarEmojiCell"
    @IBOutlet weak var eventEmojiIconImageView: UIImageView!
    @IBOutlet weak var emojiTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func descriptionConfigureCell(with set: EmojiNameAndImage) {
        eventEmojiIconImageView.image = UIImage(named: set.EmojiImage)
        emojiTitleLabel.text = set.title
    }
    
    func findImageNameWithkey(imageKey : String) -> String {
        let imageForKey: [String : String] = [
            "ut" : "UrgentIcon",
            "wm" : "GroupMeetIcon",
            "fd" : "ApprovedFullIcon",
            "bir" : "BirthdayCakeIcon",
            "hol" : "HolidayIcon",
            "afd" : "AppliedFullIcon",
            "mhd" : "ApprovedMHIcon",
            "ehd" : "ApprovedEHIcon",
            "hpt" : "PriorityIcon",
            "aehd" : "AppliedEHIcon",
            "amhd" : "AppliedMHIcon"
        ]
        return imageForKey[imageKey] ?? ""
    }
    
    func todayEventCellonfigure(with set: Event) {
        
        print(set)
        var eventImage = findImageNameWithkey(imageKey: set.key ?? "")
        eventEmojiIconImageView.image = UIImage(named: eventImage)
        emojiTitleLabel.text = set.value
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "calenderEmojiDiscriptionCollectionViewCell", bundle: nil)
    }

}

struct EmojiNameAndImage {
    let title: String
    let EmojiImage: String
}
