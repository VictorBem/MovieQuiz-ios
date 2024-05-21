//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Victor on 19.05.2024.
//

import XCTest

@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    
  func testGetValueInRange() throws {
        let array = [1, 1, 2, 3, 4]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetVlueOutOfRange() throws {
        let array = [1, 1, 2, 3, 5]

        let value = array[safe: 20]
        
        XCTAssertNil(value)
    }
}


