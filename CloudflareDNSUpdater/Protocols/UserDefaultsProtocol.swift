//
//  UserDefaultsProtocol.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol UserDefaultsProtocol: AnyObject {
    func string(forKey defaultName: String) -> String?
    func setValue(
        _ value: Any?,
        forKey key: String
    )
    func bool(forKey defaultName: String) -> Bool
}
