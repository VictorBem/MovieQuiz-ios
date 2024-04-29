//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Victor on 15.04.2024.
//

import UIKit

struct AlertModel {
    //текст заголовка алерта
    let title: String
    //текст сообщения алерта
    let message: String
    //текст для кнопки алерта
    let buttonText: String
    //замыкание без параметров для действия по кнопке алерта
    let completion: () -> () 
    
}

