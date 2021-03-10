import Combine
import Foundation

protocol QuoteServiceDataPublisher {
    func publisher() -> AnyPublisher<Data, URLError>
}
