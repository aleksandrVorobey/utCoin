//
//  UserDefaults+Extension.swift
//  utCoin
//
//  Created by admin on 13.09.2022.
//

import Foundation

extension UserDefaults {
    
    private enum UserDefaultsKeys: String {
        case isEnter
    }
    var isEnter: Bool {
        get {
            bool(forKey: UserDefaultsKeys.isEnter.rawValue)
        } set {
            setValue(newValue, forKey: UserDefaultsKeys.isEnter.rawValue)
        }
    }
}
