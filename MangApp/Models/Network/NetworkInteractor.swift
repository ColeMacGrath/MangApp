//
//  RequestManager.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import Foundation

struct ServerResponse<Content: Codable>: Codable {
    let metadata: Metadata?
    var items: Content?
    let data: Content?
    
    var content: Content? {
        return items ?? data
    }
    
    enum CodingKeys: String, CodingKey {
        case metadata
        case items
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.metadata = try container.decodeIfPresent(Metadata.self, forKey: .metadata)
        
        do {
            if let items = try container.decodeIfPresent(Content.self, forKey: .items) {
                self.items = items
                self.data = nil
            } else if let data = try container.decodeIfPresent(Content.self, forKey: .data) {
                self.items = nil
                self.data = data
            } else {
                self.items = nil
                self.data = try Content(from: decoder)
            }
        } catch {
            self.items = nil
            self.data = nil
        }
    }
}

struct Metadata: Codable {
    let page: Int?
    let total: Int?
    let per: Int?
}

struct NetworkResponse<JSON: Codable> {
    let data: JSON?
    let status: URLRequestResult
    let metadata: Metadata?
}

enum URLRequestResult: Int {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
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
        guard let postRequest: URLRequest = .request(method: .POST, url: url, body: request, authorization: true, appAuthenticated: true) else { return .badRequest }
        let response = await perform(request: postRequest, responseType: LoginResponse.self)
        guard let response else { return .appUnavailable }
        
        if let token = response.data?.user.authToken,
           KeychainManager.shared.save(token: token) {
            return response.status
        }
        return .appUnavailable
    }
    
    func renew() async -> URLRequestResult {
        guard let url: URL = .renew,
              let request: URLRequest = .request(method: .POST, url: url, authenticated: true) else { return .badRequest }
        let response = await perform(request: request, responseType: LoginResponse.self)
        guard let response else { return .appUnavailable }
        
        if let token = response.data?.user.authToken,
           KeychainManager.shared.save(token: token) {
            return response.status
        }
        return .appUnavailable
    }
    
    func mangasArray(collectionType: CollectionViewType) async -> (status: URLRequestResult, mangas: [Manga]?) {
        let url: URL? = collectionType == .best ? .bestMangas : .mangas
        guard let url,
              let getRequest: URLRequest = .request(method: .GET, url: url) else { return (.badRequest, nil) }
        
        let response = await perform(request: getRequest, responseType: [Manga].self)
        return (response?.status ?? .appUnavailable, response?.data)
    }
    
    func signUp(email: String, password: String) async -> URLRequestResult {
        guard let url: URL = .users else { return .badRequest }
        let bodyRequest = SignUpRequest(email: email, password: password)
        guard let postRequest: URLRequest = .request(method: .POST, url: url, body: bodyRequest, appAuthenticated: true) else { return .badRequest}
        guard let response = await perform(request: postRequest, responseType: SignUpRequest.self)?.status else { return .appUnavailable }
        return response
    }
    
    func perform<JSON: Codable>(request: URLRequest, responseType: JSON.Type) async -> NetworkResponse<JSON>? {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return nil }
            var defaultResponse: URLRequestResult = .appUnavailable
            let result = URLRequestResult(rawValue: httpResponse.statusCode) ?? defaultResponse
            
            if result == .unauthorized {
                _ = KeychainManager.shared.deleteToken()
                isLoggedIn = false
            } else if (200...299).contains(httpResponse.statusCode) {
                defaultResponse = .ok
            }
            
            guard !data.isEmpty else {
                return NetworkResponse(data: nil, status: result, metadata: nil)
            }
            guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"), contentType.contains("application/json") else {
                return decodedDataForPlainText(data: data, responseType: responseType)
            }
            
            if JSON.self is [OwnManga].Type {
                return decodedDataForJSONArray(data: data, responseType: responseType)
            } else if JSON.self is [String].Type || JSON.self is [Author].Type {
                return self.decodedDataForJSONArray(data: data, responseType: responseType)
            } else {
                return self.decodedDataForJSONObject(data: data, responseType: responseType)
            }
            
        } catch { return nil }
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
            guard let content = serverResponse.content else { return nil }
            return NetworkResponse(data: content, status: .ok, metadata: serverResponse.metadata)
        } catch { return nil }
    }
    
    private func decodedDataForJSONArray<JSON: Codable>(data: Data, responseType: JSON.Type) -> NetworkResponse<JSON>? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        do {
            let decodedArray = try decoder.decode(JSON.self, from: data)
            return NetworkResponse(data: decodedArray, status: .ok, metadata: nil)
        } catch { return nil }
    }
}
