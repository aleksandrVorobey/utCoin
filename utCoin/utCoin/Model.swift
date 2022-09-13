//
//  Model.swift
//  utCoin
//
//  Created by admin on 12.09.2022.
//

import Foundation

struct CodePhoneRequest: Codable {
    let successful: Bool
    let errorMessage, errorMessageCode: String
    let normalizedPhone, explainMessage: String
}

struct PasswordRequest: Codable {
    let successful: Bool
    let errorMessage, errorMessageCode: String
}
