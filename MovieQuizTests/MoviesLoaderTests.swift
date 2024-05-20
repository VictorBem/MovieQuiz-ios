//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Victor on 19.05.2024.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
            
        let expectation = expectation(description: "Loading expectation")
            
        loader.loadMovies { resilt in
            switch resilt {
            case.success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case.failure(_):
                XCTFail("Unexpectad failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
        
        func testFailureLoading() throws {
            let stubNetworkClient = StubNetworkClient(emulateError: false)
            let loader = MoviesLoader(networkClient: stubNetworkClient)
                
            let expectation = expectation(description: "Loading expectation")
                
            loader.loadMovies { resilt in
                switch resilt {
                case.success(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                case.failure(_):
                    XCTFail("Unexpectad failure")
                }
            }
            waitForExpectations(timeout: 1)
        }
}
