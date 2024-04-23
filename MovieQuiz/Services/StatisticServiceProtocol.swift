//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Victor on 22.04.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
    
    func store(correct count: Int, total amount: Int) 
}
