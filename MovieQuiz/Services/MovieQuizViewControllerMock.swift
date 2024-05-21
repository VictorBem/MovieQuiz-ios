//
//  MovieQuizViewControllerMock.swift
//  MovieQuiz
//
//  Created by Victor on 21.05.2024.
//

import Foundation

import Foundation

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func enableOrDisableButtons(disable: Bool) {
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    }
    
    func show(quiz result: MovieQuiz.AlertModel) {
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
    }
    
    func showLoadingIndicator() {
    }
    
    func hideLoadingIndicator() {
    }
}
