//
//  MoviesLoading.swift
//  MovieQuiz
//
//  Created by Victor on 29.04.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
