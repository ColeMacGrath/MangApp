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
    private(set) var token: String?
    
    private init() {
        guard ((self.token?.isEmpty) == nil) else { return }
        guard let token = self.retrieve(identifier: identifier) else { return }
        self.token = token
    }
    
    var hasToken: Bool {
        self.token != nil
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
            self.token = token
            return save(data: data, identifier: identifier)
        } catch {
            return false
        }
    }
    
    func save(dictionary: Dictionary<String, Any>, identifier: String? = nil) -> Bool {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return false }
        let identifier = identifier ?? self.identifier
        UserDefaults.standard.set(Date(), forKey: "lastRenewalDate")
        return self.save(data: data, identifier: identifier)
    }
    
    func retrieve(identifier: String) -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else { return nil }
        
        do {
            guard let result = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> else { return nil }
            return result[identifier]
        } catch { return nil }
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
