import SwiftData
import SwiftUI

enum SortOrder: LocalizedStringResource, Identifiable, CaseIterable {
  case status
  case title
  case author

  var id: Self {
    self
  }
}

struct BookListView: View {
  @State var createNewBook = false
  @State private var navPath = NavigationPath()
  @State private var sortOrder = SortOrder.status
  @State private var filter = ""

  var body: some View {
    NavigationStack(path: $navPath) {
      VStack {
        Picker("", selection: $sortOrder) {
          ForEach(SortOrder.allCases) { sortOrder in
            Text("Sort by \(sortOrder.rawValue)")
              .tag(sortOrder)
          }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .buttonStyle(.bordered)

        BookList(sortOrder: sortOrder, filterString: filter)
          .searchable(text: $filter, prompt: Text("Filter on title or author."))
      }
      .navigationTitle("My Books")
      .toolbar {
        Button {
          createNewBook = true
        } label: {
          Image(systemName: "plus.circle.fill")
            .imageScale(.large)
        }
      }
      .navigationDestination(for: Book.self) { book in
        EditBookView()
          .environmentObject(EditBookViewModel(book: book))
      }
      .sheet(isPresented: $createNewBook) {
        NewBookView()
          .presentationDetents(.init([.medium]))
      }
    }
  }
}

#Preview {
  let preview = Preview(Book.self)
  preview.addExamples(Book.MOCK)
  return BookListView()
    .modelContainer(preview.container)
}
