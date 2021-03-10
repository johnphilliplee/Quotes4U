import CoreData
import Foundation

extension QuoteManagedObject {
    static func save(quote: Quote, inViewContext viewContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: String(describing: QuoteManagedObject.self))

        fetchRequest.predicate = NSPredicate(format: "quote = %@", quote.quote)

        if let results = try? viewContext.fetch(fetchRequest),
           let existing = results.first as? QuoteManagedObject
        {
            existing.quote = quote.quote
        } else {
            let newQuote = self.init(context: viewContext)
            newQuote.quote = quote.quote
        }

        do {
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}

extension Collection where Element == QuoteManagedObject, Index == Int {
    func delete(at indices: IndexSet, inViewContext viewContext: NSManagedObjectContext) {
        indices.forEach { index in
            viewContext.delete(self[index])
        }

        do {
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
