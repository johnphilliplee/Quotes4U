import Foundation

struct Quote: Codable {
    let quote: String

    init(quote: String = "") {
        self.quote = quote
    }
}

extension Quote {
    static var starter: Quote {
        return Quote(quote: "There is nothing to fear but fear itself.")
    }

    static var error: Quote {
        return Quote(quote: "Hello. There was an error.")
    }
}
