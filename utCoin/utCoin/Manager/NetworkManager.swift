//
//  NetworkManager.swift
//  utCoin
//
//  Created by admin on 12.09.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    
    func requestPasswordPhone(phoneNumber: String, phoneNumberPassword: String, completion: @escaping (Result<PasswordRequest, Error>) -> Void) {
        baseRequest(for: ApiResponse.urlPhonePassword, phoneNumber: phoneNumber, phoneNumberPassword: phoneNumberPassword, completion: completion)
    }
    
    func requestCodePhone(phoneNumber: String, completion: @escaping (Result<CodePhoneRequest, Error>) -> Void) {
        baseRequest(for: ApiResponse.urlCallCode, phoneNumber: phoneNumber, completion: completion)
    }
    
    private func baseRequest<T: Decodable>(for url: String, phoneNumber: String, phoneNumberPassword: String? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        var fullUrl: String
        if phoneNumberPassword != nil {
            fullUrl = url + phoneNumber + "&password=" + phoneNumberPassword!
        } else {
            fullUrl = url + phoneNumber
        }
        guard let url = URL(string: fullUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(json))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } .resume()
    }
}
