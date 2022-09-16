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
    
    func fetchSearch(completion: @escaping (Result<Search, Error>) -> Void) {
        baseRequest(for: ApiResponse.urlSearch, completion: completion)
    }
    
    func fetchSearchRequest(searchText: String, completion: @escaping (Result<Search, Error>) -> Void) {
        baseRequest(for: ApiResponse.urlSearch, searchText: searchText, completion: completion)
    }
    
    private func baseRequest<T: Decodable>(for url: String, phoneNumber: String? = nil, phoneNumberPassword: String? = nil, searchText: String? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        var fullUrl: String
        if phoneNumber != nil && phoneNumberPassword != nil {
            fullUrl = url + phoneNumber! + "&password=" + phoneNumberPassword!
        } else if phoneNumber != nil {
            fullUrl = url + phoneNumber!
        } else if searchText != nil {
            fullUrl = url + searchText!
        } else {
            fullUrl = url
        }
        
        print("URL: \(fullUrl)")
        guard let url = URL(string: fullUrl) else { print("Not Url"); return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("ERROR")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else { return }
            print(data)
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
    
    func getImageFrom(url: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
