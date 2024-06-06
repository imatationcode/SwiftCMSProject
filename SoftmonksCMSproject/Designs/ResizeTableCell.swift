//
//  ResizeTableCell.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 06/06/24.
//

import UIKit

func adjustableTableCellSize(for tableView: UITableView, iPadSize: CGFloat, iPhoneSize: CGFloat) {
    if UIDevice.current.userInterfaceIdiom == .pad {
        tableView.rowHeight = iPadSize
    } else {
        tableView.rowHeight = iPhoneSize
    }
    
}
