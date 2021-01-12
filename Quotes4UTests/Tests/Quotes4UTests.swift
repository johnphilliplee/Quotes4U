//
//  Quotes4UTests.swift
//  Quotes4UTests
//
//  Created by John Lee on 1/12/21.
//

import Combine
import XCTest
import SwiftUI
@testable import Quotes4U

class Quotes4UTests: XCTestCase {
    private lazy var testQuote = self.testQuote(forResource: "TestQuote")
    private lazy var error = URLError(.badServerResponse)
    private var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
    
    private func testQuote(forResource resource: String) -> (data: Data, value: Quote) {
      let bundle = Bundle(for: type(of: self))
      
      guard let url = bundle.url(forResource: resource, withExtension: "json"),
        let  data = try? Data(contentsOf: url),
        let quote = try? JSONDecoder().decode(Quote.self, from: data)
        else { fatalError("Failed to load \(resource)") }
      
      return (data, quote)
    }
    
    private func mockQuoteService(withError: Bool = false) -> MockQuoteService {
        MockQuoteService(data: testQuote.data, error: withError ? error : nil)
    }
    
    private func viewModel(withError error: Bool = false) -> HomeViewModel {
        HomeViewModel(service: mockQuoteService(withError: error))
    }
    
    func test_backgroundColorFor50TranslationPercentIsGreen() {
      // Given
        let viewModel = self.viewModel()
        let translation = 0.5
        let expected = Color.green
        var result = Color.clear
        
        viewModel.$backgroundColor
            .sink {
                result = $0
            }
            .store(in: &subscriptions)
      // When

        viewModel.updateBackgroundColorBasedOnTranslation(translation)
        
      // Then
        XCTAssert(result == expected, "Color expected to be \(expected) but was \(result)")
    }
    
    func test_decisionStateFor60TranslationPercentIsLiked() {
      // Given
        let viewModel = self.viewModel()
        let translation = 0.6
        let bounds = CGRect(x: 0, y: 0, width: 414, height: 896)
        let x = bounds.width
        let expected: DecisionState = .liked
        var result: DecisionState = .neutral
        
        viewModel.$decisionState
            .sink {
                result = $0
            }
            .store(in: &subscriptions)
        
      // When
        viewModel.updateDecisionStateForTranslation(translation, andPredictedEndLocationX: x, inBounds: bounds)
      // Then
        XCTAssert(result == expected, "Decision state expected to be \(expected) but was \(result)")
    }
    
    func test_decisionStateFor59TranslationPercentIsNeutral() {
      // Given
        let viewModel = self.viewModel()
        let translation = 0.59
        let bounds = CGRect(x: 0, y: 0, width: 414, height: 896)
        let x = bounds.width
        let expected: DecisionState = .neutral
        var result: DecisionState = .liked
        
        viewModel.$decisionState
            .sink {
                result = $0
            }
            .store(in: &subscriptions)
      // When
      
        viewModel.updateDecisionStateForTranslation(translation, andPredictedEndLocationX: x, inBounds: bounds)
        
      // Then
        XCTAssert(result == expected, "Decision state expected to be \(expected) but was \(result)")
    }
    
    func test_fetchQuoteSucceeds() {
        // Given
        let viewModel = self.viewModel()
        let expectation = self.expectation(description: #function)
        let expected = self.testQuote.value
        var result: Quote!
        
        viewModel.$quote
          .dropFirst()
          .sink(receiveValue: {
            result = $0
            expectation.fulfill()
          })
          .store(in: &subscriptions)
        
        // When
        viewModel.fetchQuote()
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(result.quote == expected.quote, "Quote expected to be \(expected) but was \(String(describing: result))")
    }
    
    func test_fetchJokeReceivesErrorQuote() {
        // Given
        let viewModel = self.viewModel(withError: true)
        let expectation = self.expectation(description: #function)
        let expected = Quote.error
        var result: Quote!

        viewModel.$quote
          .dropFirst()
          .sink(receiveValue: {
            print($0)
            result = $0
            expectation.fulfill()
          })
          .store(in: &subscriptions)

        // When
        viewModel.fetchQuote()

        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(result.quote == expected.quote, "Joke expected to be \(expected) but was \(String(describing: result))")
    }

}
