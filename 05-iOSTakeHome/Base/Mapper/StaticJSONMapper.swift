//
//  StaticJSONMapper.swift
//  05-iOSTakeHome
//
//  Created by kopresh desai on 17/09/25.
//

import Foundation

struct StaticJSONMapper {
    static func decode<T: Decodable>(file: String, type: T.Type) throws -> T {
//        guard let path = Bundle.main.path(forResource: file, ofType: "json"),
//              let data = FileManager.default.contents(atPath: "path") else {
//            throw MappingError.failedToGetContents
//        }
        let data: Data
        guard let path = Bundle.main.url(forResource: file, withExtension: nil)
        else {
            throw MappingError.failedToGetContents
        }

        do {
            data = try Data(contentsOf: path)
        } catch {
            throw MappingError.failedToGetContents
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
