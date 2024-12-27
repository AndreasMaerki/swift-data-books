import SwiftData
import SwiftUI

@main
struct BooksAppApp: App {
  let container: ModelContainer
  var body: some Scene {
    WindowGroup {
      BookListView()
    }
    .modelContainer(container)
  }

  init() {
    // Register all models in the array. If a model contins a reference
    // to another model (like Book to Quote) it isn't necessary
    let schema = Schema([Book.self])
    // Name the DB and pass the schema
    let config = ModelConfiguration("MyBooks.store", schema: schema)
    do {
      container = try ModelContainer(for: schema, configurations: config)
    } catch {
      fatalError("could not configure container")
    }
    print(URL.documentsDirectory.path())
  }
}
