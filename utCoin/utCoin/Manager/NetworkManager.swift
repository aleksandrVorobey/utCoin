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
        let url = URLFactory.url(path: Path.phoneCodePassword.rawValue, phone: phoneNumber, password: phoneNumberPassword).absoluteString
        baseRequest(for: url, completion: completion)
    }
    
    func requestCodePhone(phoneNumber: String, completion: @escaping (Result<CodePhoneRequest, Error>) -> Void) {
        let url = URLFactory.url(path: Path.phoneCode.rawValue, phone: phoneNumber).absoluteString
        baseRequest(for: url, completion: completion)
    }
    
    func fetchSearchRequest(page: Int = 0, searchText: String, completion: @escaping (Result<Search, Error>) -> Void) {
        let url = URLFactory.url(paramPage: page, paramSearch: searchText, path: Path.search.rawValue).absoluteString
        baseRequest(for: url, completion: completion)
    }
    
    
    private func baseRequest<T: Decodable>(for url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { print("Not Url"); return }
        
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
  
//MARK: - downloadImage
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
