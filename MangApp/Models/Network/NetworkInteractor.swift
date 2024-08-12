//
//  RequestManager.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

protocol DataInteractor {
    func login(username: String, password: String) async -> URLRequestResult
    var isLoggedIn: Bool { get set }
}

struct ServerResponse<Content: Codable>: Codable {
    let data: Content
}

struct NetworkResponse<JSON: Codable> {
    let data: JSON
    let status: URLRequestResult
}

enum URLRequestResult: Int {
    case ok = 200
    case badRequest = 400
    case appUnavailable = 999
}

@Observable
class NetworkInteractor: DataInteractor {
    static let shared = NetworkInteractor(isLoggedIn: KeychainManager.shared.hasToken)
    var isLoggedIn: Bool
    private init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
    
    func login(username: String, password: String) async -> URLRequestResult {
        guard let url: URL = .login else { return .badRequest }
        let request = LoginRequest(email: username, password: password)
        guard let postRequest: URLRequest = .post(url: url, body: request) else { return .badRequest }
        let response = await perform(request: postRequest, responseType: LoginResponse.self)
        guard let response else { return .appUnavailable }
        
        if KeychainManager.shared.save(token: response.data.user.authToken) {
            return response.status
        }
        return .appUnavailable
    }
    
    private func perform<JSON: Codable>(request: URLRequest, statusCode: Int = 200, responseType: JSON.Type) async -> NetworkResponse<JSON>? {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == statusCode else { return nil }
            
            if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"), contentType.contains("application/json") {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(ServerResponse<JSON>.self, from: data).data
                return NetworkResponse(data: decodedData, status: .ok)
            } else if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"), contentType.contains("text/plain") {
                if let plainText = String(data: data, encoding: .utf8), responseType == LoginResponse.self {
                    let userResponse = UserResponse(authToken: plainText)
                    if let loginResponse = LoginResponse(user: userResponse) as? JSON {
                        return NetworkResponse(data: loginResponse, status: .ok)
                    }
                }
                return nil
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
