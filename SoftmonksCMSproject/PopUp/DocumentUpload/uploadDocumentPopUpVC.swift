//
//  uploadDocumentPopUpVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 27/06/24.
//

import UIKit
import Alamofire
import UniformTypeIdentifiers

protocol documentPopUpDelegate: AnyObject {
    func didDismissedPopUp()
}

class uploadDocumentPopUpVC: UIViewController, UITextFieldDelegate, UIDocumentPickerDelegate {
    
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var delegateVar: documentPopUpDelegate?
    let docTypePicker = UIPickerView()
    var listOfDocsPendingList: [MandatoryDocument] = []
    var slectedDocType: String?
    var labelForSelectedDocType: String?
    var addPDFResponseVar: AddFileResponse?
    
    @IBOutlet weak var uploadDocumentTitleLabel: UILabel!
    @IBOutlet weak var documentTypeTitleLabe: UILabel!
    @IBOutlet weak var docTypeSelectionTextField: UITextField!
    @IBOutlet weak var addFileButton: UIButton!
    @IBOutlet weak var selectedFileTitleLabel: UILabel!
    @IBOutlet weak var pdfFileTitleLabel: UILabel!
    @IBOutlet weak var pdfSizeLabel: UILabel!
    @IBOutlet weak var crossButtonView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selectedFileDisplayVIew: UIView!
    @IBOutlet weak var loaderInticatorOnContentView: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFileDisplayVIew.isHidden = true
        initialDesign()
        loaderInticatorOnContentView.scaleIndicator(factor: 2.0)
        docTypeSelectionTextField.tintColor = UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMandatoryDocumentsList()
    }
    
    
    func initialDesign() {
        contentView.layer.cornerRadius = 8.0
        crossButtonView.layer.cornerRadius = 3.0
        crossButtonView.addElevatedShadow(to: crossButtonView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func tappedOnAddFileButton(_ sender: UIButton) {
        print("addFiles")
        if labelForSelectedDocType != nil {
            if (selectedFileDisplayVIew.isHidden) != false {
                selectDocument()
            } else {
                showAlert(title: "File Exist", message: "Delete Previously Uploaded file")
            }
            
        } else {
            showAlert(title: "Missing", message: "Please Select Document Type")
        }
    }
    
    
    func selectDocument() {
        let pdfFileType = UTType.pdf
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [pdfFileType])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
    
    @IBAction func tappedOnDeleteBinButton(_ sender: UIButton) {
        showDeleteAlert()
    }
    
    func showDeleteAlert() {
        let alartController = UIAlertController(title: "Delete", message: "Are You Sure You want to Delete uploaded Iteam", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { delete in
            self.deleteDcoAPICall()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alartController.addAction(cancelAction)
        alartController.addAction(deleteAction)

        self.present(alartController, animated: true)
    }

    
    @IBAction func tappedOnDoneButton(_ sender: UIButton) {
        if labelForSelectedDocType != nil {
            if (selectedFileDisplayVIew.isHidden) != true {
                self.dismiss(animated: true) {
                    self.delegateVar?.didDismissedPopUp()
                }
            } else {
                showAlert(title: "Add File", message: "Please Add Document To Upload")
            }
        } else {
            showAlert(title: "Missing", message: "Please Select Document Type")
        }
    }
    
    @IBAction func tappedOnCrossButton(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegateVar?.didDismissedPopUp()
        }
    }
    
    func showLoader(for duration: TimeInterval) {
        let loader = self.customAlert(alertTitle: "Uploading", alertDiscription: "Please Wait....")
//        loaderInticatorOnContentView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {  [weak self] in
//            self?.loaderInticatorOnContentView.stopAnimating()
            self?.dismissCutomAlert(loader: loader)
            self?.selectedFileDisplayVIew.isHidden = false
        }
    }
    
    func setupDocTypePicker() {
        print("Inside Doc Type")
        docTypePicker.delegate = self
        docTypePicker.dataSource = self
        let toolBar =  UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButttonTapped))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        doneButton.image = UIImage(named: "DoneText")
        cancelButton.image = UIImage(named: "CancelText")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton, flexibleSpace, doneButton]
        toolBar.sizeToFit()
        docTypeSelectionTextField.inputAccessoryView = toolBar
        docTypeSelectionTextField.inputView = docTypePicker
    }
    
    
    @objc func cancelButtonTapped() {
        print("Cancel Tapper")
        self.view.endEditing(true)
    }
    
    @objc func doneButttonTapped() {
        if let selectedValue = slectedDocType {
            docTypeSelectionTextField.text = selectedValue
        } else if !listOfDocsPendingList.isEmpty {
            docTypeSelectionTextField.text = listOfDocsPendingList[0].value
        }
        docTypeSelectionTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func fetchMandatoryDocumentsList() {
        let perameters: [String: Any] = ["mode":"requiredDocuments", "id":userDict?["id"]]
        AF.request(apiURL, method: .get, parameters: perameters).responseDecodable(of: RequiredDocResponse.self) { response in
            switch response.result {
            case .success(let responseData):
                // Print the mandatory documents
                print(responseData)
                self.setupDocTypePicker()
                for document in responseData.mandatoryDocuments {
                    print("Key: \(document.key), Value: \(document.value)")
                }
                self.listOfDocsPendingList = responseData.mandatoryDocuments
                self.docTypePicker.reloadAllComponents()
                
            case .failure(let error):
                self.showAlert(title: "Error", message: "Required Documents API Error")
                print("Failed to fetch documents: \(error)")
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedPDFFileURL = urls.first else {
            return
        }
        if selectedPDFFileURL.pathExtension.lowercased() == "pdf"{
            print("File Selected")
            do {
                let pdfData = try Data(contentsOf: selectedPDFFileURL)
                // Pass the PDF data to the backend
                uploadPDFToBackEnd(pdfData, fileName: selectedPDFFileURL.lastPathComponent)
            } catch {
                print("Error reading PDF file: \(error.localizedDescription)")
            }
        } else {
            // Show an alert if the selected file is not a PDF
            showAlertt()
        }
    }
    
    func uploadPDFToBackEnd(_ pdfData: Data, fileName: String) {
        showLoader(for: 3.0)
        let idString = "\(userDict?["id"] ?? "")"
        let peramters: [String: Any] = ["mode": "uploadDocuments", "id": idString, "name": "Documents", "label": labelForSelectedDocType! ]
        let header: HTTPHeaders =  ["Content-type": "multipart/form-data"]
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(pdfData, withName: "upload", fileName: fileName, mimeType: "document/pdf")
            
            for (key, value) in peramters {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
        }, to: apiURL, method: .post, headers: header).responseDecodable(of: AddFileResponse.self) { response in
            switch response.result {
            case .success(let valueResponse):
                print(valueResponse)
                if valueResponse.err == 0 {
                    print("PDF file uploaded Sucessfully")
//                    self.addfileReasponseVar = valueResponse
                    self.pdfSizeLabel.text = valueResponse.fileSize
                    self.pdfFileTitleLabel.text = fileName
                    self.addPDFResponseVar = valueResponse
                } else {
                    print("Could not Upload PDF ")
                }
                
            case .failure(let error):
                self.showAlert(title: "Error", message: "Error in Upload Document API Call")
                print("Error uploading PDF file: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteDcoAPICall() {
        let parameters: [String:Any] = ["mode":"deleteSelectedDocuments", "id": userDict?["id"], "mediaId": addPDFResponseVar?.mediaId]
        print(parameters)
        AF.request(apiURL, method: .post, parameters: parameters).response() { response in
            switch response.result {
            case .success(let valueResponse):
                self.selectedFileDisplayVIew.isHidden = true
                print(valueResponse as Any)
                print("Record Deleted Succesfully")
                self.showAlert(title: "Success", message: "Document Deleted Successfuly")
            case .failure(let errorr):
                self.showAlert(title: "Error", message: "Error in Delete Documen API Call")
                print("Could Not Delete resonse : \(errorr)")
            }
        }
    }
    
    func showAlertt() {
        let alert = UIAlertController(title: "Invalid File", message: "Please Select Only PDF files", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

extension uploadDocumentPopUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfDocsPendingList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfDocsPendingList[row].value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        slectedDocType = listOfDocsPendingList[row].value ?? ""
        labelForSelectedDocType = listOfDocsPendingList[row].key
    }
}

extension UIActivityIndicatorView {
    func scaleIndicator(factor: CGFloat) {
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
