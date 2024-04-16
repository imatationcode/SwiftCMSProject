//
//  loginCheck.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 08/04/24.
//

import Foundation

struct loginCheck: Codable {
    let err: Int
    let key, errMsg, userId, name, designation: String
    
}

struct UserDetails: Codable {
    let err: Int?
    let errMsg: String?
    let derivedClass: Int?
    let id, name, designation: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id, empCode: String?
    let exdate: JSONNull?
    let tblAdminTypeID, label, username, password: String?
    let firstName, middleName, lastName, webID: String?
    let email, phone, residenceNumber: String?
    let dob, dateOfJoining, dateOfLeaving: JSONNull?
    let address, city, state, zip: String?
    let leaveCount, sessID, qrcode, twoFactor: String?
    let actCode, pchange, lastLogin: String?
    let createdOn, updatedOn, loginCount: JSONNull?
    let eulaOn, notification, active, deleted: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id, empCode, exdate
        case tblAdminTypeID = "tblAdminTypeId"
        case label, username, password, firstName, middleName, lastName
        case webID = "webId"
        case email, phone, residenceNumber, dob, dateOfJoining, dateOfLeaving, address, city, state, zip, leaveCount
        case sessID = "sessId"
        case qrcode, twoFactor, actCode, pchange, lastLogin, createdOn, updatedOn, loginCount, eulaOn, notification, active, deleted, name
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
