//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Victor on 15.04.2024.
//

import UIKit

//final class AlertPresenter: AlertPresenterProtocol {
//    
//    private var currentController: UIViewController?
//    
//    var controller: UIViewController? {
//        get {
//            return currentController
//        }
//        
//        set {
//            currentController = newValue
//        }
//    }
//    
//    weak var delegate: AlertPresenterDelegate?
//    
//    func presentAlert(model alertModel: AlertModel) {
//        let alert = UIAlertController(
//            title: alertModel.title,
//            message: alertModel.message,
//            preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
//            alertModel.completion()
//        }
//        action.accessibilityIdentifier = alertModel.buttonText
//        
//        alert.addAction(action)
//        
//        if let currentController = currentController {
//            currentController.present(alert, animated: true, completion: nil)
//        }
//    }
//}
