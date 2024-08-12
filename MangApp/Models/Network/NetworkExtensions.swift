//
//  NetworkExntesions.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

extension URLRequest {
    static func createPostRequest(url: URL, body: Codable) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        } catch {
            return nil
        }
    }
    
    static func post(url: URL, body: Codable) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if url == .login,
               let loginRequest = self.getLoginRequest(request: request, body:  body) {
                request = loginRequest
            }
            return request
        } catch {
            return nil
        }
    }
    
    static func get(url: URL, isAuthenticated: Bool = false) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        /*if isAuthenticated {
         guard let token = KeychainHelper.standard.read() else {
         throw URLRequestError.missingToken
         }
         
         guard let strToken = String(data: token, encoding: .utf8) else {
         throw URLRequestError.tokenErrorFormat
         }
         
         request.addValue("Bearer \(strToken)", forHTTPHeaderField: "Authorization")
         }*/
        return request
    }
    
    static fileprivate func getAppToken() -> String? {
        guard let appConfigUrl = Bundle.main.url(forResource: "AppConfig", withExtension: "plist"),
              let data = try? Data(contentsOf: appConfigUrl),
              let config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let appToken = config["AppToken"] as? String else { return nil }
        return appToken
    }
    
    static fileprivate func getLoginRequest(request: URLRequest, body: Codable) -> URLRequest? {
        guard let appToken = self.getAppToken(),
              let loginBody = body as? LoginRequest else { return nil }
        var request = request
        let username = loginBody.email
        let password = loginBody.password
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else { return nil }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue(appToken, forHTTPHeaderField: "App-Token")
        return request
    }
}

