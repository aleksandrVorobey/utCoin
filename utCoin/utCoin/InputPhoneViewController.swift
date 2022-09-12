//
//  ViewController.swift
//  utCoin
//
//  Created by admin on 12.09.2022.
//

import UIKit

class InputPhoneViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ValidatePhoneViewController") as! ValidatePhoneViewController
        self.present(vc, animated: true)
    }
    
}

