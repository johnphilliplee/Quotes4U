//
//  SavedQuotes.swift
//  Quotes4U
//
//  Created by John Lee on 1/12/21.
//

import SwiftUI

struct SavedQuotesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
      sortDescriptors: [NSSortDescriptor(
                            keyPath: \QuoteManagedObject.quote,
                            ascending: true
                       )],
      animation: .default
    ) private var quotes: FetchedResults<QuoteManagedObject>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(quotes, id: \.self) { quote in
                    Text(quote.quote ?? "N/A")
                }
            }
            .navigationTitle("Saved Quotes")
        }
    }
}

struct SavedQuotes_Previews: PreviewProvider {
    static var previews: some View {
        SavedQuotesView()
    }
}
