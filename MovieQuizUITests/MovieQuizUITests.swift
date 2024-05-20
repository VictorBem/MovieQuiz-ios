//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Victor on 19.05.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(5)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() throws {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(5)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testAlertEndOfRound() {
        sleep(5)
        
        for counter in 1...10 {
            if counter % 2 == 0 {
                app.buttons["No"].tap()
                sleep(1)
            } else {
                app.buttons["Yes"].tap()
                sleep(1)
            }
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Алерт не выведен на экран")
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testHideAlertAfterButtonTap() {
        sleep(5)
        
        for counter in 1...10 {
            if counter % 2 == 0 {
                app.buttons["No"].tap()
                sleep(1)
            } else {
                app.buttons["Yes"].tap()
                sleep(1)
            }
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        sleep(5)
        
        let indexLabelTest = app.staticTexts["Index"].label
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabelTest, "1/10")
    }
}
