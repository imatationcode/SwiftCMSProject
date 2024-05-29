////
////  imageAPI.swift
////  SoftmonksCMSproject
////
////  Created by Shivakumar Harijan on 27/05/24.
////
//
//import Foundation
//
//public func uploadImage(image: UIImage, parameters: [String: Any], backendURI: String = backendURL, header: [String:String]) -> Observable<(success: Bool, msg: String?)>{
//    return Observable.create { observer in
//      var headers = header
//      headers["Content-type"] = "multipart/form-data"
//      let dataToUpload = image.jpegData(compressionQuality: 0.75)
//      Alamofire.upload(multipartFormData: { multipartFormData in
//        for (key,value) in parameters {
//          multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
//        }
//        multipartFormData.append(dataToUpload!, withName: "upload", fileName: self.getFileName(), mimeType: "image/jpeg")
//      }, to: backendURL, method: .post, headers: headers, encodingCompletion: { encodingResult in
//        switch encodingResult {
//        case .success(let upload, _, _):
//          upload.uploadProgress { progress in
//            DispatchQueue.main.async {
//              //show loader uploading
//            }
//          }
//          upload.responseJSON { response in
//            guard response.result.isSuccess else {
//              observer.onNext((success: false, msg: "Image upload failed. Please try again."))
//              print("Error while uploading file: \(response.result.error!)")
//              return
//            }
//            do{
//              let responseJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String:Any]
//              print(responseJSON)
//              if let errMsg = responseJSON["errMsg"] as? String, errMsg != "" {
//                observer.onNext((success: false, msg: errMsg))
//              } else{
//                observer.onNext((success: true, msg: "Uploaded succesfully."))
//              }
//            } catch {
//              observer.onNext((success: false, msg: "Image upload failed. Please try again."))
//            }
//          }
//        case .failure(_):
//          observer.onError(APIErrors.serverError)
//        }
//      })
//      return Disposables.create()
//    }
//  }
