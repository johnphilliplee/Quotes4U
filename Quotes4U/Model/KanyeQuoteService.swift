import Combine
import Foundation

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
