//
//  NetworkExntesions.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation



extension URLRequest {
    static func request(method: HTTPMethod, url: URL, body: Codable? = nil, authorization: Bool = false, authenticated: Bool = false, appAuthenticated: Bool = false) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if authenticated {
            guard let token = KeychainManager.shared.token else { return nil }
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if appAuthenticated {
            request.setValue(getAppToken(), forHTTPHeaderField: "App-Token")
        }
        if method == .POST,
           let body {
            request = setPostRequest(request: request, body: body)
        }
        if authorization {
            guard let body,
                  let base64String = getLoginRequest(body: body) else { return nil}
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    static fileprivate func setPostRequest(request: URLRequest, body: Codable) -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {}
        return request
    }
    
    static fileprivate func getAppToken() -> String? {
        guard let appConfigUrl = Bundle.main.url(forResource: "AppConfig", withExtension: "plist"),
              let data = try? Data(contentsOf: appConfigUrl),
              let config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let appToken = config["AppToken"] as? String else { return nil }
        return appToken
    }
    
    static fileprivate func getLoginRequest(body: Codable) -> String? {
        guard let loginBody = body as? LoginRequest else { return nil }
        let username = loginBody.email
        let password = loginBody.password
        let loginString = "\(username):\(password)"
        return loginString.data(using: .utf8)?.base64EncodedString()
    }
}

