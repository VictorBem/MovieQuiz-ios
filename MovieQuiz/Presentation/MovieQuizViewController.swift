import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    private var currentButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticService = StatisticServiceImplementation()
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        alertPresenter.controller = self
        self.alertPresenter = alertPresenter
        
        textLabel.textColor = UIColor.ypWhite
        counterLabel.textColor = UIColor.ypWhite
        titleLabel.textColor = UIColor.ypWhite
        noButton.titleLabel?.textColor = UIColor.ypBlack
        yesButton.titleLabel?.textColor = UIColor.ypBlack
        
        let mainFont = UIFont(name: "YSDisplay-Medium", size: 20)
        
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = mainFont
        titleLabel.font = mainFont
        noButton.titleLabel?.font = mainFont
        yesButton.titleLabel?.font = mainFont
        
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    func didAlertPresented() {
        currentQuestionIndex = 0
        correctAnswers = 0
        
        if let questionFactory = questionFactory {
            questionFactory.requestNextQuestion()
        }
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        answerGived(answer: false)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        answerGived(answer: true)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
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
                
                let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен",
                                                        message: resultString,
                                                        buttonText: "Сыграть еще раз",
                                                        completion: didAlertPresented)
                
                if let alertPresenter = self.alertPresenter {
                    alertPresenter.presentAlert(model: alertModel)
                }
            }
        } else {
            currentQuestionIndex += 1
            if let questionFactory = self.questionFactory {
                questionFactory.requestNextQuestion()
            }
        }
    }
    
    private func answerGived(answer: Bool) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == answer
        {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
