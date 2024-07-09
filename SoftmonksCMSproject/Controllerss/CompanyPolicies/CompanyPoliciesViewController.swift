//
//  CompanyPoliciesViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 12/06/24.
//

import UIKit
import Alamofire

class CompanyPoliciesViewController: UIViewController, LogoDisplayable, UITableViewDelegate, UITableViewDataSource {
    
    var APIResponseVar: PersonalDetialsResponse?
    var policiLists: [UsuserDocuments] = []

    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var policiesListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " Company Policies"
        policiesListTableView.register(UINib(nibName: "CompanyPoliciesTableViewCell", bundle: nil), forCellReuseIdentifier: "CompanyPoliciesTableViewCell")
        policiesListTableView.dataSource = self
        policiesListTableView.delegate = self
        adjustableTableCellSize(for: policiesListTableView, iPadSize: 80, iPhoneSize: 50)
        addLogoToFooter()
        policyListAPICall()
    }
    
    func policyListAPICall() {
        let perameters: [String: Any] = ["mode":"getCompanyPolicy"]
        policiesListAPIRequest(perameterList: perameters)

    }
    
    func updateTableViewUI() {
        DispatchQueue.main.async {
            self.policiesListTableView.reloadData()
        }
    }
    
    func policiesListAPIRequest(perameterList:[String: Any]) {
        AF.request(apiURL, method: .get, parameters: perameterList, encoding: URLEncoding.default)
            .responseDecodable(of: PersonalDetialsResponse.self) { response in
                switch response.result {
                case .success(let responseData):
                    if responseData.err == 0 {
                        print("the polici List \(responseData)")
                        self.APIResponseVar = responseData
                        self.policiLists = responseData.Documents ?? []
                        self.updateTableViewUI()
                    } else {
                        self.showAlert(title: "Error", message: responseData.errMsg ?? "Could Not Found Policies")
                    }
                    
                case .failure(let error):
                    self.showAlert(title: "Error", message: "Failed To Load Data From API")
                    print(error)
                }
            }
    }
    
    
    @IBAction func clickedOnSearch(_ sender: UIButton) {
        if let keyword: String = searchTextField.text {
            let parameterList: [String: Any] = ["mode":"getSearchCompanyPolicy", "searchKey": keyword]
            policiesListAPIRequest(perameterList: parameterList)

        } else {
            self.showAlert(title: "Missing", message: "Enter Some Keywords to Search")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        policiLists.count
    }
    
//    @objc func viewDocumentClicked() {
//        print("asda")
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = policiesListTableView.dequeueReusableCell(withIdentifier: "CompanyPoliciesTableViewCell", for: indexPath) as! CompanyPoliciesTableViewCell
        let policy = policiLists[indexPath.row]
        cell.ViewButton.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        cell.configureValues(document: policy)
        cell.ViewButton.tag = indexPath.row
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let document = policiLists[indexPath.row]
//        openWebView(with: document.imagePath ?? "")
//    }
    
    @objc func openWebView(_ sender:UIButton ) {
        let rowIndex = sender.tag
        let urlString = policiLists[rowIndex].imagePath ?? ""
        let url = URL(string: urlString)
        let webViewController = WebViewController()
        webViewController.url = url
        webViewController.title = policiLists[rowIndex].filename
        present(webViewController, animated: true)
//        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    
}
