//
//  RequestManager.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

struct ServerResponse<Content: Codable>: Codable {
    let metadata: Metadata?
    let items: Content?
    let data: Content?
    
    var content: Content? {
        return items ?? data
    }
}

struct Metadata: Codable {
    let page: Int?
    let total: Int?
    let per: Int?
}

struct NetworkResponse<JSON: Codable> {
    let data: JSON
    let status: URLRequestResult
    let metadata: Metadata?
}

enum URLRequestResult: Int {
    case ok = 200
    case badRequest = 400
    case appUnavailable = 999
}

@Observable
class NetworkInteractor {
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
    
    func mangasArray(collectionType: CollectionViewType) async -> (status: URLRequestResult, mangas: [Manga]?) {
        let url: URL? = collectionType == .best ? .bestMangas : .mangas
        guard let url else { return (.badRequest, nil) }
        let getRequest: URLRequest = .get(url: url)
        let response = await perform(request: getRequest, responseType: [Manga].self)
        return (response?.status ?? .appUnavailable, response?.data)
    }
    
    func perform<JSON: Codable>(request: URLRequest, statusCode: Int = 200, responseType: JSON.Type) async -> NetworkResponse<JSON>? {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == statusCode else { return nil }
            
            guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"), contentType.contains("application/json") else {
                return decodedDataForPlainText(data: data, responseType: responseType)
            }
            
            if JSON.self is [String].Type {
                return self.decodedDataForJSONArray(data: data, responseType: responseType)
            } else {
                return self.decodedDataForJSONObject(data: data, responseType: responseType)
            }
            
           
        } catch {
            return nil
        }
    }
    
    private func decodedDataForPlainText<JSON: Codable>(data: Data, responseType: JSON.Type) -> NetworkResponse<JSON>? {
        guard let plainText = String(data: data, encoding: .utf8), responseType == LoginResponse.self else { return nil }
        let userResponse = UserResponse(authToken: plainText)
        guard let loginResponse = LoginResponse(user: userResponse) as? JSON else { return nil }
        return NetworkResponse(data: loginResponse, status: .ok, metadata: nil)
    }
    
    private func decodedDataForJSONObject<JSON: Codable>(data: Data, responseType: JSON.Type) -> NetworkResponse<JSON>? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        do {
            let serverResponse = try decoder.decode(ServerResponse<JSON>.self, from: data)
            return NetworkResponse(data: serverResponse.content!, status: .ok, metadata: serverResponse.metadata)
        } catch { return nil }
    }
    
    private func decodedDataForJSONArray<JSON: Codable>(data: Data, responseType: JSON.Type) -> NetworkResponse<JSON>? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        do {
            let decodedArray = try decoder.decode(JSON.self, from: data)
            return NetworkResponse(data: decodedArray, status: .ok, metadata: nil)
        } catch {
            print("Failed to decode JSON array: \(error)")
            return nil
        }
    }
}
