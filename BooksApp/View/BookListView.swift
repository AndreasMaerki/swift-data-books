import SwiftData
import SwiftUI

struct BookListView: View {
  @Environment(\.modelContext) var context
  @Query(sort: \Book.title) var books: [Book]
  @State var createNewBook = false
  @State private var navPath = NavigationPath()

  var body: some View {
    NavigationStack(path: $navPath) {
      Group {
        if books.isEmpty {
          ContentUnavailableView("Enter some books", systemImage: "book.fill")
        } else {
          List {
            ForEach(books) { book in
              NavigationLink(value: book) {
                bookEntry(book)
              }
            }
            .onDelete { indexSet in
              indexSet.forEach { context.delete(books[$0]) }
            }
          }
          .listStyle(.plain)
        }
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
        EditBookView(book: book)
      }
      .sheet(isPresented: $createNewBook) {
        NewBookView()
          .presentationDetents(.init([.medium]))
      }
    }
  }

  private func bookEntry(_ book: Book) -> some View {
    HStack {
      book.icon
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.title2)
        Text(book.author)
          .foregroundStyle(.secondary)
        if let rating = book.rating {
          bookRating(rating)
        }
      }
    }
  }

  private func bookRating(_ rating: Int) -> some View {
    HStack {
      ForEach(1 ..< rating, id: \.self) { _ in
        Image(systemName: "star.fill")
          .imageScale(.small)
          .foregroundColor(.yellow)
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
