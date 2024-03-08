//
//  menuIteam.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 21/02/24.
//

import Foundation


struct MenuItem {
    private(set) public var menutitle: String
    private(set) public var menuImg: String
    
    init(menutitle: String, menuImg: String) {
        self.menutitle = menutitle
        self.menuImg = menuImg
    }
}

