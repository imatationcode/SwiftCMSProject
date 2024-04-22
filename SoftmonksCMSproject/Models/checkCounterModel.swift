//
//  checkCounterModel.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 17/04/24.
//

import Foundation
struct checkCounterModel: Codable {
    let cDate: String?
    var isCheckedIn: Int?
    let timeBtnTxt: String
    var timeBtnType: String?
    let breakBtn: Int?
    let breakBtnTxt, breakBtnType, clockInTime, clockOutTime: String?
    let duration: String?
    let err: Int?
    let errMsg: String?
    let derivedClass: Int?
}

struct CheckInOutData: Codable {
  let isCheckedIn: Int?
  let timeBtnTxt: String?
  let timeBtnType: String?
  let breakBtn: Int?
  let breakBtnTxt: String?
  let breakBtnType: String?
  let clockInTime: String?
  let clockOutTime: String?
  let duration: String? // Optional to handle null value for clockOutTime
}
