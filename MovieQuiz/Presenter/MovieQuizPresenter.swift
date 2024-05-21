//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Victor on 20.05.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    static let yesButtonTag = true
    static let noButtonTag = false
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        guard let questionFactory = questionFactory else { return }
        questionFactory.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        guard let viewController = viewController, let questionFactory = questionFactory else { return }
        viewController.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        let message = error.localizedDescription
        proceedToNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func resetQuestionIndex () {
        currentQuestionIndex = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func resetCorrectAnswers() {
        correctAnswers = 0
    }
    
    private func increaseCorrectAnswers() {
        correctAnswers += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        answerGived(answer: MovieQuizPresenter.yesButtonTag)
    }
    
    func noButtonClicked() {
        answerGived(answer: MovieQuizPresenter.noButtonTag)
    }
   
    private func answerGived(answer: Bool) {
        guard let viewController = viewController else {return}
        viewController.enableOrDisableButtons(disable: true)
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == answer {
            proceedWithAnswer(isCorrect: true)
        } else {
            proceedWithAnswer(isCorrect: false)
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            if var statisticService = statisticService {
                let lastAccurance = statisticService.totalAccuracy
                let lastGamesCount = statisticService.gamesCount
                
                let totalCorrectAnswers = lastAccurance * Double(lastGamesCount) * Double(questionsAmount) + Double(correctAnswers)
                let totalQuestions = (lastGamesCount + 1) * questionsAmount
                
                statisticService.totalAccuracy = totalCorrectAnswers / Double(totalQuestions)
                statisticService.gamesCount += 1
                statisticService.store(correct: correctAnswers, total: questionsAmount)
                
                let currentResult = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n"
                let currentQuantityOfQuizes = "Количество сыграных квизов: \(statisticService.gamesCount)\n"
                let currentBestResult = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n"
                let avarageAccurancy = "Средняя точность: \(String(format: "%.2f", (statisticService.totalAccuracy) * 100.0))%"
                
                let resultString = currentResult + currentQuantityOfQuizes + currentBestResult + avarageAccurancy
                
                guard let viewController = viewController else { return }
                let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен!",
                                                        message: resultString,
                                                        buttonText: "Сыграть еще раз",
                                                        completion: restartGame)
                
                viewController.show(quiz: alertModel)
            }
        } else {
            switchToNextQuestion()
            if let questionFactory = self.questionFactory {
                questionFactory.requestNextQuestion()
            }
        }
    }
    
    private func requestNextQuestion() {
        if let questionFactory = questionFactory {
            questionFactory.requestNextQuestion()
        }
    }
    
    private func proceedToNetworkError(message: String) {
        guard let viewController = viewController else { return }
        viewController.hideLoadingIndicator()
        
        guard let questionFactory = questionFactory else { return }
        let alertModel: AlertModel = AlertModel(title: "Network error",
                                                message: message,
                                                buttonText: "Попробовать еще раз",
                                                completion: questionFactory.loadData)
        
        viewController.show(quiz: alertModel)
    }
    
    private func restartGame() {
        resetQuestionIndex()
        resetCorrectAnswers()
        requestNextQuestion()
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        guard let viewController = viewController else { return }
        viewController.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        if isCorrect {
            increaseCorrectAnswers()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            proceedToNextQuestionOrResults()
            viewController.enableOrDisableButtons(disable: false)
        }
    }
}
