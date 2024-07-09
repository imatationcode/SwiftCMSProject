//
//  DocumentsVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit
import Alamofire

class DocumentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userDict = UserDefaults.standard.dictionary(forKey: "UserDetails")
    var documetsDetailsVar: PersonalDetialsResponse?
    var documentList: [UsuserDocuments] = []
    var docUploadPopUpVar: uploadDocumentPopUpVC?
    

    @IBOutlet weak var documentsTitleLabel: UILabel!
    @IBOutlet weak var mainProfileImageView: ProfileImageCustomeView!
    @IBOutlet weak var documentsListTableView: UITableView!
    var array = [2,3,4,5,6,7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainProfileImageView.mainIconImage.image = UIImage(named: "ColordescriptionIcon")
        documentsListTableView.register(UINib(nibName: "DocumentsTableCell", bundle: nil), forCellReuseIdentifier: "DocumentsTableCell")
        documentsListTableView.delegate = self
        documentsListTableView.dataSource = self
        loadUserDocuments()
        adjustableTableCellSize(for: documentsListTableView, iPadSize: 100, iPhoneSize: 60)
        
    }
    
    func loadUserDocuments() {
        let perameters: [String : Any] = ["mode": "displayAllDocuments", "id": userDict?["id"]]
        AF.request(apiURL, method: .post, parameters: perameters, encoding: URLEncoding.default)
            .responseDecodable(of: PersonalDetialsResponse.self) { [weak self] response in
                guard let self = self else{ return }
                switch response.result {
                case .success(let response):
                    print(response)
                    if (response.err == 0) {
                        self.documetsDetailsVar = response
                        self.documentList = response.Documents!
                        self.updateListTabeleUI()
                        
                    } else {
                        self.showAlert(title: "Error", message: response.errMsg!)
                    }
                    print("Done WIth API Call")
                case .failure(let error):
                    //                    self.loaderActivityIncicatior.stopAnimating()
                    print(error)
                    self.showAlert(title: "Error", message: "Error in API Call")
                }
            }
    }
    
    @IBAction func tappedOnUploadDocument(_ sender: UIButton) {
        print("tapped on Upload doc")
        let popUpVC = uploadDocumentPopUpVC()
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.delegateVar = self
        present(popUpVC, animated: true)
        self.docUploadPopUpVar = popUpVC
    }

    func updateListTabeleUI() {
        DispatchQueue.main.async {
            self.documentsListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return documentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsListTableView.dequeueReusableCell(withIdentifier: "DocumentsTableCell", for: indexPath) as! DocumentsTableCell
        let detailRecord = documentList[indexPath.row]
        cell.configValues(with: detailRecord)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document = documentList[indexPath.row]
        openWebView(with: document.imagePath ?? "")
    }
    
    func openWebView(with urlString: String) {
        let url = URL(string: urlString)
        let webViewController = WebViewController()
        webViewController.url = url
        present(webViewController, animated: true)
//        navigationController?.pushViewController(webViewController, animated: true)
    }
}

extension DocumentsVC : documentPopUpDelegate {
    func didDismissedPopUp() {
        print("Inside Protocole Functin")
        loadUserDocuments()
    }
}

