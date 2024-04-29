//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Victor on 22.04.2024.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isGameBetter(newGame: GameRecord) -> Bool {
        return correct < newGame.correct
    }
}
