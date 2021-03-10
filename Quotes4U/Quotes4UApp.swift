import CoreData
import SwiftUI

@main
struct Quotes4UApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
                .environment(\.managedObjectContext, CoreDataStack.viewContext)
        }
    }
}

private enum CoreDataStack {
    static var viewContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "QuoteModel")

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("\(#file), \(#function), \(error!.localizedDescription)")
            }
        }

        return container.viewContext
    }()

    static func save() {
        guard viewContext.hasChanges else { return }

        do {
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
