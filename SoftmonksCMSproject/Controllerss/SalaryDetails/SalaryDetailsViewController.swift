//
//  SalaryDetailsViewController.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 30/05/24.
//

import UIKit

class SalaryDetailsViewController: UIViewController, LogoDisplayable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var salarySlipsTableView: UITableView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    
    let months = ["January", "February", "March", "April", "May", "June",
                    "July", "August", "September", "October", "November", "December"]
    let years = Array(2015...2024)

    var pickerView: UIPickerView!
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Salary Reciepts"
        salarySlipsTableView.register(UINib(nibName: "SalaryReciptsTableViewCell", bundle: nil), forCellReuseIdentifier: "SalaryReciptsTableViewCell")
        salarySlipsTableView.dataSource = self
        salarySlipsTableView.delegate = self
        adjustableTableCellSize(for: salarySlipsTableView, iPadSize: 80, iPhoneSize: 50)
        addLogoToFooter()
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = salarySlipsTableView.dequeueReusableCell(withIdentifier: "SalaryReciptsTableViewCell", for: indexPath)
        return cell
    }
    
}
