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

struct CheckInOutData: Codable {
  let timeBtn: Int?
  let timeBtnTxt: String?
  let timeBtnType: String?
  let breakBtn: Int?
  let breakBtnTxt: String?
  let breakBtnType: String?
  let clockInTime: String?
  let clockOutTime: String? // Optional to handle null value for clockOutTime
}
