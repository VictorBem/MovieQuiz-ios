//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Victor on 14.04.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private static let defaultRatingForQuestion = 7
    private static let defaultIndex = 0
    private static let defaultRating: Float = 0.0
    private static let minimumRatingForQuestion = 7
    private static let maximumRationgForQuestion = 9
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoader, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case (.success(let mostPopularMovies)):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case (.failure(let error)):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? QuestionFactory.defaultIndex
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? QuestionFactory.defaultRating
            
            let questionRating = (QuestionFactory.minimumRatingForQuestion...QuestionFactory.maximumRationgForQuestion).randomElement() ?? QuestionFactory.defaultRatingForQuestion
            
            let text = "Рейтинг этого фильма больше чем \(questionRating)?"
            
            let correctAnswer = rating > Float(questionRating)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
