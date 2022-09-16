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
        
        setupConfig()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let vc = ValidatePhoneViewController.instantiate()
        vc.phoneNumber = phoneNumberTextField.text
        self.present(vc, animated: true)
    }
    
    private func setupConfig() {
        nextButton.backgroundColor = .lightGray
        nextButton.isEnabled = false
        
        phoneNumberTextField.delegate = self
    }
    
    deinit {
        print("InputVC")
    }
    
}

extension InputPhoneViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if  textField.text!.count >= 10 && textField.text!.count < 15 {
            nextButton.isEnabled = true
            nextButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .lightGray
        }
    }
}
