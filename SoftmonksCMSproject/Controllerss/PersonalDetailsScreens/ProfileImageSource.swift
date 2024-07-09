//
//  ProfileImageSource.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 11/06/24.
//

import UIKit
import Alamofire

struct UploadResponse: Decodable {
    let err: Int?
    let errMsg: String?
    let name: String?
    let id: String?
    let slot: String?
    let maxNum: String?
    let filePath: String?
    let mediaId: Int?
    let mediaPath: String?
    let mediaWebPath: String?
    let mediaWebsitePath: String?
    let successMsg: String?
    let derivedClass: Int?
    let profilePhoto: String?
}

class ImageStorage {

    static func saveImageToDocumentsDirectory(image: UIImage, imageName: String) -> URL? {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            try? data.write(to: filename)
            return filename
        }
        return nil
    }

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    static func saveImagePathToUserDefaults(path: URL) {
        UserDefaults.standard.set(path.path, forKey: "profileImagePath")
    }

    static func loadImageFromDocumentsDirectory(imageName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(imageName)
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }

    static func loadImagePathFromUserDefaults() -> URL? {
        if let path = UserDefaults.standard.string(forKey: "profileImagePath") {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
}

var photoDataResponseVar: UploadResponse?


