//
//  SalaryDetailsViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 30/05/24.
//

import UIKit

class SalaryDetailsViewController: UIViewController, LogoDisplayable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var salarySlipsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogoToFooter()
        title = "Salary Reciepts"
        salarySlipsTableView.register(UINib(nibName: "SalaryReciptsTableViewCell", bundle: nil), forCellReuseIdentifier: "SalaryReciptsTableViewCell")
        salarySlipsTableView.dataSource = self
        salarySlipsTableView.delegate = self
                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = salarySlipsTableView.dequeueReusableCell(withIdentifier: "SalaryReciptsTableViewCell", for: indexPath)
        return cell
    }
    
}
