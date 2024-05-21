//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Victor on 19.05.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
