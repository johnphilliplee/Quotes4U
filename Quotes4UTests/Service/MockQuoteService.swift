import Combine
import Foundation
@testable import Quotes4U

struct MockQuoteService: QuoteServiceDataPublisher {
    let data: Data
    let error: URLError?

    init(data: Data, error: URLError?) {
        self.data = data
        self.error = error
    }

    func publisher() -> AnyPublisher<Data, URLError> {
        let passThroughSubject = PassthroughSubject<Data, URLError>()

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            if let error = error {
                passThroughSubject.send(completion: .failure(error))
            } else {
                passThroughSubject.send(data)
            }
        }

        return passThroughSubject.eraseToAnyPublisher()
    }
}
