//
//  MidImageView.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 21/05/24.
//

import UIKit

class MidImageView: UIView {

    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var outerContainerView: UIView!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        creatBoard()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        creatBoard()
    }
    
    func creatBoard() {
        guard let nibView = Bundle.main.loadNibNamed("MidImageView", owner: self, options: nil)?.first as? UIView else {
                 return
             }
             addSubview(nibView)
             nibView.frame = self.bounds
             nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
             
             imageBackgroundView.layer.cornerRadius = imageBackgroundView.bounds.size.width / 2
             imageBackgroundView.layer.masksToBounds = true
    }
    
}
