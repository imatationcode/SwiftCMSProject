//
//  checkCounterModel.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 17/04/24.
//

import Foundation
struct checkCounterModel: Codable {
    let cDate: String?
    let timeBtn: Int?
    let timeBtnTxt, timeBtnType: String?
    let breakBtn: Int?
    let breakBtnTxt, breakBtnType, clockInTime, clockOutTime: String?
    let err: Int?
    let errMsg: String?
    let derivedClass: Int?
}
