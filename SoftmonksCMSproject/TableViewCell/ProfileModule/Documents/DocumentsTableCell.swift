//
//  DocumentsTableCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 30/05/24.
//

import UIKit

class DocumentsTableCell: UITableViewCell {
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var documentTitleLabel: UILabel!
    @IBOutlet weak var documentUploadDateLabel: UILabel!
    @IBOutlet weak var uploadDateTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustFontSizeForDevice(textFields: [], labels: [documentTitleLabel, documentUploadDateLabel, uploadDateTitle])
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
