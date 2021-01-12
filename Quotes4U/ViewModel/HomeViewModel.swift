//
//  HomeViewModel.swift
//  Quotes4U
//
//  Created by John Lee on 1/12/21.
//

import Foundation
import SwiftUI

enum DecisionState {
    case liked, disliked, neutral
}

class HomeViewModel: ObservableObject {
    @Published var quote: Quote = Quote.starter
    @Published var fetching: Bool = false
    @Published var backgroundColor: Color = Color.gray
    @Published var decisionState: DecisionState = .neutral
    
    private var service: QuoteServiceDataPublisher
    
    init(service: QuoteServiceDataPublisher = KanyeQuoteService()) {
        self.service = service
        
        $quote
            .map { _ in false }
            .assign(to: &$fetching)
    }
    
    func fetchQuote() {
        service.publisher()
            .retry(1)
            .decode(type: Quote.self, decoder: JSONDecoder())
            .replaceError(with: Quote.error)
            .receive(on: DispatchQueue.main)
            .assign(to: &$quote)
    }

    func reset() {
        backgroundColor = Color.gray
    }
    
    func updateBackgroundColorBasedOnTranslation(_ translation: Double) {
        switch translation {
        case ...(-0.5):
            backgroundColor = Color.red
        case 0.5...:
            backgroundColor = Color.green
        default:
            backgroundColor = Color.gray
        }
    }
    
    public func updateDecisionStateForTranslation(
      _ translation: Double,
      andPredictedEndLocationX x: CGFloat,
      inBounds bounds: CGRect) {
      switch (translation, x) {
      case (...(-0.6), ..<0):
        decisionState = .disliked
      case (0.6..., bounds.width...):
        decisionState = .liked
      default:
        decisionState = .neutral
      }
    }
}
