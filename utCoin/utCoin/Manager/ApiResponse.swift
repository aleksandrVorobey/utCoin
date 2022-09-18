//
//  ApiResponse.swift
//  utCoin
//
//  Created by admin on 13.09.2022.
//

import Foundation

enum Path: String {
    case search = "/loyality/search"
    case phoneCode = "/loyality/login_step1"
    case phoneCodePassword = "/loyality/login_step2"
}

struct URLFactory {
    static func url(paramPage: Int = 0, paramSearch: String? = nil, path: String, phone: String? = nil, password: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "utcoin.one"
        components.path = path
        components.queryItems = [URLQueryItem(name: "search_string", value: paramSearch),
                                 URLQueryItem(name: "page", value: "\(paramPage)"),
                                 URLQueryItem(name: "phone", value: phone),
                                 URLQueryItem(name: "password", value: password)]
        return components.url!
    }
}
