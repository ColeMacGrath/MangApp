//
//  KeychainManager.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

class KeychainManager {
    static let shared = KeychainManager()
    private let identifier = "AppToken"
    private init() {}
    
    var hasToken: Bool {
        retrieve(identifier: identifier) != nil
    }

    private func save(data: Data, identifier: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: data] as [String: Any]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    func save(token: String) -> Bool {
        do {
            let data = try JSONSerialization.data(withJSONObject: [identifier: token], options: [])
            return save(data: data, identifier: identifier)
        } catch {
            return false
        }
    }
    
    func save(dictionary: Dictionary<String, Any>, identifier: String? = nil) -> Bool {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return false }
        let identifier = identifier ?? self.identifier
        return self.save(data: data, identifier: identifier)
    }

    func retrieve(identifier: String) -> [String: Any]? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == noErr,
              let data = item as? Data else { return nil }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
            return dictionary
        } catch {
            return nil
        }
    }
    
    func deleteToken(identifier: String? = nil) -> Bool {
        let identifier = identifier ?? self.identifier
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: identifier] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
