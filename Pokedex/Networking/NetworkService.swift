//
//  NetworkService.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation
import Combine

enum NetworkError: Error {
    case unwrap
    case invalidUrl
    case invalidJSON
    case invalidStatusCode(Int)
    case `internal`(Error)
}

class NetworkService {
    var baseUrlString: String { "https://pokeapi.co" }
    
    private let urlSession: URLSession = .shared
    
    private let encoder: JSONEncoder = JSONEncoder()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func getRequest(forPath path: String, params: [URLQueryItem] = []) throws -> URLRequest {
        guard var url = URL(string: baseUrlString)?.appendingPathComponent(path) else {
            throw NetworkError.invalidUrl
        }
        
        url.append(queryItems: params)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
        
    func postRequest<T: Encodable>(
        forPath path: String,
        params: [URLQueryItem] = [],
        requestBody: T? = nil
    ) throws -> URLRequest {
        guard var url = URL(string: path)?.appendingPathComponent(path) else {
            throw NetworkError.invalidUrl
        }
        
        url.append(queryItems: params)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        if let requestBody {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try encoder.encode(requestBody)
        }
        
        return request
    }
    
    func fetch<T: Decodable>(request: URLRequest, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response throws -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                        200...299 ~= httpResponse.statusCode else {
                    let code = (response as? HTTPURLResponse)?.statusCode
                    throw NetworkError.invalidStatusCode(code ?? -1)
                }
                
                return data
            }
            .decode(type: T.self, decoder: self.decoder)
            .mapError { .internal($0) }
            .eraseToAnyPublisher()
    }
}
