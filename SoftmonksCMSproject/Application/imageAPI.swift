//
//  imageAPI.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 27/05/24.
//
////
//import UIKit
//import Foundation
//import Alamofire
//
//func uploadImage(image: UIImage, parameters: [String: Any], backendURL: String, header: [String:String], completion: @escaping (Bool, String?) -> Void) {
//  var headers = header
//  headers["Content-type"] = "multipart/form-data"
//  guard let dataToUpload = image.jpegData(compressionQuality: 0.75) else {
//    completion(false, "Failed to convert image to data")
//    return
//  }
//  AF.upload(multipartFormData: { multipartFormData in
//    for (key, value) in parameters {
//      guard let data = (value as! String).data(using: .utf8) else {
//        completion(false, "Failed to convert parameter value to data")
//        return
//      }
//      multipartFormData.append(data, withName: key)
//    }
//    multipartFormData.append(dataToUpload, withName: "upload", fileName: getFileName(), mimeType: "image/jpeg")
//  }, to: backendURL, method: .post, headers: headers) { encodingResult in
//    switch encodingResult {
//    case .success(let upload):
//      upload.uploadProgress { progress in
//        DispatchQueue.main.async {
//          // Show loader uploading (your implementation)
//        }
//      }
//      upload.responseJSON { response in
//        if let error = response.result.error {
//          completion(false, "Image upload failed. Please try again. Error: \(error)")
//          print("Error while uploading file:", error)
//          return
//        }
//        
//        guard let data = response.data else {
//          completion(false, "Failed to get response data")
//          return
//        }
//        
//        do {
//          let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
//          if let errMsg = responseJSON["errMsg"] as? String, errMsg != "" {
//            completion(false, errMsg)
//          } else {
//            completion(true, "Uploaded successfully.")
//          }
//        } catch {
//          completion(false, "Image upload failed. Please try again.")
//        }
//      }
//    case .failure(let error):
//      completion(false, "Server error: \(error)")
//      print("Error during upload:", error)
//    }
//  }
//}
//func getFileName() -> String {
//   return "upload.jpg"
//}

//public func uploadImage(image: UIImage, parameters: [String: Any], backendURL: String, headers: [String: String], completion: @escaping (Result<String, Error>) -> Void) {
//  var finalHeaders = headers
//  finalHeaders["Content-type"] = "multipart/form-data"
//
//  guard let dataToUpload = image.jpegData(compressionQuality: 0.75) else {
//    completion(.failure(NSError(domain: "Image Upload Error", code: 1, userInfo: ["message": "Failed to convert image to data"])))
//    return
//  }
//
//  AF.upload(multipartFormData: { multipartFormData in
//    for (key, value) in parameters {
//      if let stringValue = value as? String {
//        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
//      } else {
//        // Handle non-string values here (e.g., ignore, log a warning)
//      }
//    }
//    multipartFormData.append(dataToUpload, withName: "upload", fileName: "ProfilePhoto", mimeType: "image/jpeg")
//  }, to: backendURL, method: .post, headers: finalHeaders) { encodingResult in
//    switch encodingResult {
//    case .success(let upload):
//      upload.uploadProgress { progress in
//        // Optional: You can update UI based on progress here
//      }
//      upload.responseJSON { response in
//        if let error = response.result.error {
//          completion(.failure(error))
//          return
//        }
//
//        guard let responseJSON = response.data else {
//          completion(.failure(NSError(domain: "Image Upload Error", code: 3, userInfo: ["message": "Failed to get response data"])))
//          return
//        }
//
//        do {
//          let json = try JSONSerialization.jsonObject(with: responseJSON, options: []) as! [String: Any]
//          if let errMsg = json["errMsg"] as? String, errMsg != "" {
//            completion(.failure(NSError(domain: "Image Upload Error", code: 4, userInfo: ["message": errMsg])))
//          } else {
//            completion(.success("Uploaded successfully."))
//          }
//        } catch {
//          completion(.failure(NSError(domain: "Image Upload Error", code: 5, userInfo: ["message": "Error parsing response: \(error.localizedDescription)"])))
//        }
//      }
//    case .failure(let error):
//      completion(.failure(error))
//    }
//  }
//}
