//
//  QuoteService.swift
//  Quotes4U
//
//  Created by John Lee on 1/12/21.
//

import Foundation
import Combine

protocol QuoteServiceDataPublisher{
    func publisher() -> AnyPublisher<Data, URLError>
}
