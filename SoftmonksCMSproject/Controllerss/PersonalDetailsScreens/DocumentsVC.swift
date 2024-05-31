//
//  DocumentsVC.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 20/05/24.
//

import UIKit

class DocumentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    }
    
    @IBAction func tappedOnUploadDocument(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsListTableView.dequeueReusableCell(withIdentifier: "DocumentsTableCell", for: indexPath) as! DocumentsTableCell
        return cell
    }
    
}
