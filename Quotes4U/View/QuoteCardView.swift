//
//  QuoteCardView.swift
//  Quotes4U
//
//  Created by John Phillip Lee on 1/14/21.
//

import SwiftUI

struct QuoteCardView: View {
    let quote: String
    var body: some View {
        Text(quote)
            .font(.title2)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding()
    }
}

struct QuoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCardView(quote: "Preview Quote")
    }
}
