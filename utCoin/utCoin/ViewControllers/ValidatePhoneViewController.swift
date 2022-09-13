//
//  ValidatePhoneViewController.swift
//  utCoin
//
//  Created by admin on 12.09.2022.
//

import UIKit

class ValidatePhoneViewController: UIViewController {
    
    @IBOutlet weak var currentPhoneLabel: UILabel! {
        didSet {
            guard let phoneNumber = phoneNumber else { return }
            currentPhoneLabel.text! += " \(phoneNumber)"
        }
    }
    
    @IBOutlet weak var currentPhoneTextField: UITextField!
    @IBOutlet weak var sendAgainButton: UIButton!
    
    var phoneNumber: String?
    //var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPhoneTextField.delegate = self
        fetchNumberCode()
    }
    
    private func fetchNumberCode() {
        guard let phoneNumber = phoneNumber else { return }
        NetworkManager.shared.requestCodePhone(phoneNumber: phoneNumber) { [weak self] result in
            switch result {
            case .success(let codePhoneRequest):
                if codePhoneRequest.successful == true {
                    self?.showAlert(title: "", message: codePhoneRequest.explainMessage)
                } else {
                    self?.showAlert(title: "", message: codePhoneRequest.errorMessage)
                }
            case .failure(let error):
                self?.showAlert(title: "Ошибка запроса", message: error.localizedDescription)
            }
        }
    }
    
    private func checkPassword() {
        guard let phoneNumber = phoneNumber else { return }
        NetworkManager.shared.requestPasswordPhone(phoneNumber: phoneNumber, phoneNumberPassword: currentPhoneTextField.text!) { [weak self] result in
            switch result {
            case .success(let passwordRequest):
                if passwordRequest.successful == true {
                    let searchVC = SearchViewController.instantiate()
                    searchVC.password = self?.currentPhoneTextField.text
                    UserDefaults.standard.isEnter = true
                    let navigationController = UINavigationController(rootViewController: searchVC)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.present(navigationController, animated: true)
                } else {
                    self?.showAlert(title: "Ошибка", message: passwordRequest.errorMessage)
                }
            case .failure(let error):
                self?.showAlert(title: "Ошибка запроса", message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func sendAgainPressed(_ sender: UIButton) {
        fetchNumberCode()
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    deinit {
        print("ValidateVC")
    }
    
}

extension ValidatePhoneViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharactersCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharactersCount {
            return false
        }
        let newLenght = currentCharactersCount + string.count - range.length
        return newLenght <= 4
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count == 4 {
            textField.resignFirstResponder()
            checkPassword()
        }
    }
}
