//
//  Endpoint.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 23/09/25.
//

import Foundation

enum Endpoint {
    case people(page: Int)
    case detail(id: Int)
    case create(submissionData: Data?)
}

extension Endpoint {
    
    enum MethodType {
        case GET
        case POST(data: Data?)
    }
    
    var host: String { "reqres.in" }
    
    var path: String {
        switch self {
        case .people,
                .create:
            return "/api/users"
        case .detail(let id):
            return "/api/users/\(id)"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .people,
             .detail:
            return .GET
        case .create(let data):
            return .POST(data: data)
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .people(let page):
            return ["page": "\(page)"]
        default:
            return nil
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = queryItems?.compactMap { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        
        #if DEBUG
        requestQueryItems?.append(URLQueryItem(name: "delay", value: "3"))
        #endif
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
