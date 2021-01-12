//
//  KanyeQuoteService.swift
//  Quotes4U
//
//  Created by John Lee on 1/12/21.
//

import Foundation
import Combine

struct KanyeQuoteService {
    private var url: URL {
        urlComponents.url!
    }
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.kanye.rest"
        return components
    }
}

extension KanyeQuoteService: QuoteServiceDataPublisher {
    func publisher() -> AnyPublisher<Data, URLError> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
