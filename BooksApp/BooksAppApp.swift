import SwiftData
import SwiftUI

@main
struct BooksAppApp: App {
  var body: some Scene {
    WindowGroup {
      BookListView()
    }
    .modelContainer(for: Book.self)
  }

  init() {
    print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }
}
