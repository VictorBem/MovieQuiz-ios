//
//  Movie.swift
//  MovieQuiz
//
//  Created by Victor on 17.04.2024.
//

import Foundation

struct Movie: Codable {
  let id: String
  let rank: String
  let title: String
  let fullTitle: String
  let year: String
  let image: String
  let crew: String
  let imDbRating: String
  let imDbRatingCount: String
}
