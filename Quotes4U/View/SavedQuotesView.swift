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
                .onDelete(perform: delete)
            }
            .navigationTitle("Saved Quotes")
        }
    }

    func delete(at offsets: IndexSet) {
        quotes.delete(at: offsets, inViewContext: viewContext)
    }
}

struct SavedQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedQuotesView()
    }
}
