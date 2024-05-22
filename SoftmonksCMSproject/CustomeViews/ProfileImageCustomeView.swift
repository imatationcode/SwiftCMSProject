//
//  ProfileImageCustomeView.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 15/03/24.
//

import UIKit

class ProfileImageCustomeView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var outerContainerView: UIView!
    @IBOutlet weak var innerImageView: UIView!
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
        Bundle.main.loadNibNamed("ProfileImageCustomeView", owner: self, options: nil)
        addSubview(outerContainerView)
        outerContainerView.frame = self.bounds
        outerContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        innerImageView.layer.cornerRadius = 10
        innerImageView.layer.masksToBounds = true

    }


}
