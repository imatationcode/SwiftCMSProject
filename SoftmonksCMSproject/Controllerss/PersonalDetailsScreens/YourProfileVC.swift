//
//  YourPorofileVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit
import Alamofire
import SDWebImage

class YourProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userProfileData: PersonalDetialsResponse?
    var profileImageDataVar: UploadResponse?
    var detailsList: [UserBasicInformation] = []
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    
    @IBOutlet weak var staffTextLabel: UILabel!
    @IBOutlet weak var loaderActivityIncicatior: UIActivityIndicatorView!
    @IBOutlet weak var staffCodeLabel: UILabel!
    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var profileImageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFontSizeForDevice(textFields: [], labels: [staffCodeLabel, staffTextLabel])
        loaderActivityIncicatior.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        mainImageView.applyGradient(colors: ["00359A", "95CCFF"], angle: -180.0,conRads: 0.0)
        profileImage.layer.cornerRadius = profileImage.bounds.size.height / 2
        mainImageView.layer.cornerRadius = mainImageView.bounds.size.height / 2
        mainImageView.layer.masksToBounds = true
        self.detailsTableView.register(UINib(nibName: "PersonalDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalDetailsTableViewCell")
        self.detailsTableView.delegate = self
        self.detailsTableView.dataSource = self
        profileDataAPICall()
        adjustableTableCellSize(for: detailsTableView, iPadSize: 80, iPhoneSize: 50)
        
        print("about to call displayImage IN Viewdidload ")
//        displayImageFromServer()
        //        if let imagePath = ImageStorage.loadImagePathFromUserDefaults() {
        //            profileImage.image = ImageStorage.loadImageFromDocumentsDirectory(imageName: imagePath.lastPathComponent)
        //        }
        
        //        profileImage.image = UIImage(named: "passportImg")
        //        mainImageView.mainIconImage.image = UIImage(named: "passportImg")
        
    }
    
    func displayImageFromServer() {
        let perameters: [String : Any] = ["mode":"displayProfilePhoto", "id": userDict?["id"] as Any]
        AF.request(apiURL, method: .post, parameters: perameters).responseDecodable(of: UploadResponse.self) { response in
            switch response.result {
            case .success(let dataa):
                print(dataa)
                let imageLinkString: String = dataa.profilePhoto!
                let imageURL = URL(string: imageLinkString)
                print(imageURL as Any)
                self.profileImage.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "person"), options: .continueInBackground)
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func profileDataAPICall() {
        loaderActivityIncicatior.startAnimating()
        let paramenters: [String : Any] = ["mode": "getUserData", "id": userDict?["id"]!]
        AF.request(apiURL, method: .post, parameters: paramenters, encoding: URLEncoding.default, headers: nil)
            .responseDecodable(of: PersonalDetialsResponse.self){ [weak self] response in
                guard let self = self else{ return }
                switch response.result {
                case .success(let response):
                    print(response)
                    self.loaderActivityIncicatior.stopAnimating()
                    self.userProfileData = response
                    self.updateUI()
                    let imageLinkString: String = (response.profilePhoto) ?? ""
                    let imageURL = URL(string: imageLinkString)
                    self.profileImage.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "person"), options: .continueInBackground)
                    print("Done WIth API Call")
                case .failure(let error):
                    self.loaderActivityIncicatior.stopAnimating()
                    print(error)
                    self.showAlert(title: "Error", message: "Error in API Call")
                }
            }
        loaderActivityIncicatior.stopAnimating()
    }
    
    func updateUI() {
        self.staffCodeLabel.text = userProfileData?.staffCode
        self.detailsList = userProfileData?.userData ?? []
        DispatchQueue.main.async {
            self.detailsTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.detailsTableView.dequeueReusableCell(withIdentifier: "PersonalDetailsTableViewCell", for: indexPath) as! PersonalDetailsTableViewCell
        //        cell.viewContrroller = self
        let detailRecord = detailsList[indexPath.row]
        cell.configValues(with: detailRecord)
        return cell
        
    }
    
    @IBAction func tappedOnProfileImage(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Import Image From", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showImagePickerController(sourceType: .camera)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        // For iPad
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            let alert = UIAlertController(title: "Source Not Available", message: "This source type is not available on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadDocument(selectedImage)
            print("here is what in select \(selectedImage)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadDocument(_ doc: UIImage) {
        let userIdString: String
        if let userId = userDict?["id"] {
            userIdString = String(describing: userId)
        } else {
            userIdString = "Unknown ID"
        }
        let parameters: [String: Any] = ["mode": "uploadDocuments", "id": userIdString, "name":"Image"]
        print(parameters)
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        guard let dataToUpload = doc.jpegData(compressionQuality: 0.75) else {
            print("Failed to convert image to JPEG data")
            return
        }
        print("\(dataToUpload)")
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(dataToUpload, withName: "upload", fileName: "Profile.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                if let valueData = (value as? String)?.data(using: .utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }
            
        }, to: apiURL, method: .post, headers: headers).responseDecodable(of: UploadResponse.self) { response in
            switch response.result {
            case .success(let responseData):
                print(responseData)
                self.profileDataAPICall()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

