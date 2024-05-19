//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Victor on 29.04.2024.
//

import Foundation

struct NetworkClient {
    private static let okRequest = 200
    private static let multipleChoicesRequest = 300
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < NetworkClient.okRequest || response.statusCode >= NetworkClient.multipleChoicesRequest {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}

