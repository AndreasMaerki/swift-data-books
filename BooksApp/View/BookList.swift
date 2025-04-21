import SwiftData
import SwiftUI

struct BookList: View {
  @Environment(\.modelContext) var context
  @Query var books: [Book]

  init(sortOrder: SortOrder, filterString: String) {
    let sortDescriptors: [SortDescriptor] = switch sortOrder {
    case .status:
      [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
    case .title:
      [SortDescriptor(\Book.title)]
    case .author:
      [SortDescriptor(\Book.author)]
    }

    let predicate = #Predicate<Book> { book in
      book.title.localizedStandardContains(filterString)
        || book.author.localizedStandardContains(filterString)
        || filterString.isEmpty
    }
    _books = Query(filter: predicate, sort: sortDescriptors)
  }

  var body: some View {
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
  }

  private func bookEntry(_ book: Book) -> some View {
    HStack {
      book.icon
        .font(.title2)
        .foregroundStyle(.secondary)
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.title2)
        Text(book.author)
          .foregroundStyle(.secondary)
        if let rating = book.rating {
          bookRating(rating)
        }
        if let genres = book.genres {
          GenreStackView(genres: genres)
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
  return NavigationStack {
    BookList(sortOrder: .status, filterString: "")
      .modelContainer(preview.container)
  }
}
