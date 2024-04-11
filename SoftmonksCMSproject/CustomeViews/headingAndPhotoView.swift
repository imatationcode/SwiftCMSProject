//
//  headingAndPhotoView.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 15/03/24.
//

import UIKit

final class headingAndPhotoView: UIView {
    @IBOutlet var ContainerViewOfPhoto: UIView!
    
    @IBOutlet weak var BlueRingWithSolidWhiteFIllingImage: UIImageView!
    @IBOutlet weak var BlurBlueCircleBackViewImage: UIImageView!
    @IBOutlet weak var mainIconImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
        }
    
    private func commitInit(){
        Bundle.main.loadNibNamed("headingAndPhotoView", owner: self, options: nil)
        addSubview(ContainerViewOfPhoto)
        ContainerViewOfPhoto.frame = self.bounds
        ContainerViewOfPhoto.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
}
