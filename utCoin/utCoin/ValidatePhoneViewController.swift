//
//  ValidatePhoneViewController.swift
//  utCoin
//
//  Created by admin on 12.09.2022.
//

import UIKit

class ValidatePhoneViewController: UIViewController {

    @IBOutlet weak var currentPhoneLabel: UILabel!
    @IBOutlet weak var currentPhoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
