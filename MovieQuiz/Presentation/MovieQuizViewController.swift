import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var textLabel: UILabel?
    @IBOutlet private var counterLabel: UILabel?
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var noButton: UIButton?
    @IBOutlet private var yesButton: UIButton?
    private var currentButton: UIButton?
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    private var presenter: MovieQuizPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        guard let textLabel = textLabel, let counterLabel = counterLabel, let titleLabel = titleLabel,
              let noButton = noButton, let yesButton = yesButton else { return }
        
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
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let presenter = presenter else { return }
        presenter.noButtonClicked()
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let presenter = presenter else { return }
        presenter.yesButtonClicked()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        guard let imageView = imageView else { return }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        guard let activityIndicator = activityIndicator else { return }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        guard let activityIndicator = activityIndicator else { return }
        
        activityIndicator.isHidden = true
    }
    
    func enableOrDisableButtons(disable: Bool) {
        guard let noButton = noButton, let yesButton = yesButton else { return }
        
        noButton.isEnabled = !disable
        yesButton.isEnabled = !disable
    }

    func show(quiz step: QuizStepViewModel) {
        guard let textLabel = textLabel, let counterLabel = counterLabel,let imageView = imageView else { return }
    
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default){ _ in
                result.completion()
            }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
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
