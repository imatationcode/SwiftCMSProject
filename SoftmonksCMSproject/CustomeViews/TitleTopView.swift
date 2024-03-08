//
//  TitleTopView.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 22/02/24.
//

import UIKit

class TitleTopView: UIView {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    
    private func commitInit(){
        Bundle.main.loadNibNamed("TitleTopView", owner: self,options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
