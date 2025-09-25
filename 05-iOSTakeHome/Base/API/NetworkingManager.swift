//
//  NetworkingManager.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 20/09/25.
//

import Foundation

final class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T: Codable>(_ endpoint: Endpoint,
                             type: T.Type,
                             completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = endpoint.url else {
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(NetworkingError.custom(error: error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,(200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkingError.invaidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(T.self, from: data)
                completion(.success(res))
            } catch {
                completion(.failure(NetworkingError.failedToDecode(error: error)))
            }
        }
        
        dataTask.resume()
    }
    
    func request(_ endpoint: Endpoint,
                 completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = endpoint.url else {
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(NetworkingError.custom(error: error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,(200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            completion(.success(()))
        }
        dataTask.resume()
    }
}

extension NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invaidData
        case failedToDecode(error: Error)
    }
    
    func buildRequest(from url: URL, methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        switch methodType {
            case .GET:
                request.httpMethod = "GET"
            case .POST(let data):
                request.httpMethod = "POST"
                request.httpBody = data
        }
        // Set free api key
        request.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        return request
    }
}

extension NetworkingManager.NetworkingError {
    var errorDescription: String? {
        switch self {
            case .invalidUrl:
                return "URL isn't valid"
            case .invalidStatusCode:
                return "Status code falls into the wrong range"
            case .invaidData:
                return "Response data is invalid"
            case .failedToDecode:
                return "Failed to decode"
            case .custom(let err):
                return "Somrthing went wrong \(err.localizedDescription)"
        }
    }
}
