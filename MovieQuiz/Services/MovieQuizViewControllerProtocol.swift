//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Victor on 20.05.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: AlertModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func enableOrDisableButtons(disable: Bool)
}
