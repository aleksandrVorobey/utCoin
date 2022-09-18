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

//MARK: - SearchModel
struct Search: Codable {
    let successful: Bool
    let errorMessage, errorMessageCode: String
    let campaigns: [Campaign]
    let products: [Product]
    let more, moreCampaigns: Bool
}

struct Campaign: Codable {
    let name: String
    let cashback: String
    let actions: [Action]
    let imageUrl: String
    let paymentTime: String
}

struct Product: Codable {
    let name: String
    let cashback: String
    let actions: [Action]
    let imageUrls: [String]
    let price: String
    let campaignName: String
    let campaignImageUrl: String
    let paymentTime: String
}

struct Action: Codable {
    let value: String
    let text: String
}
