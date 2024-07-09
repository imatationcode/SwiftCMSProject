//
//  calenderEmojiDiscriptionCollectionViewCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 04/07/24.
//

import UIKit

class calendarEmojiCell: UICollectionViewCell {
    static let idetenfier = "calendarEmojiCell"
    @IBOutlet weak var emojiIconImageView: UIImageView!
    @IBOutlet weak var emojiTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureCell(with set: EmojiNameAndImage) {
        emojiIconImageView.image = UIImage(named: set.EmojiImage)
        emojiTitleLabel.text = set.title
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "calenderEmojiDiscriptionCollectionViewCell", bundle: nil)
    }

}

struct EmojiNameAndImage {
    let title: String
    let EmojiImage: String
}
