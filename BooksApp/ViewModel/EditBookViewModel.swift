import Foundation

class EditBookViewModel: ObservableObject {
  @Published var title: String
  @Published var author: String
  @Published var dateAdded: Date
  @Published var dateStarted: Date
  @Published var dateCompleted: Date
  @Published var synopsis: String
  @Published var rating: Int?
  @Published var status: Status
  @Published var recommendedBy: String
  @Published var quotes: [Quote]?
  @Published var genres: [Genre]?
  @Published var selectedBookCoverData: Data?

  private var book: Book

  init(book: Book) {
    title = book.title
    author = book.author
    dateAdded = book.dateAdded
    dateStarted = book.dateStarted
    dateCompleted = book.dateCompleted
    synopsis = book.synopsis
    rating = book.rating
    status = Status(rawValue: book.status)!
    recommendedBy = book.recommendedBy
    quotes = book.quotes
    genres = book.genres
    selectedBookCoverData = book.bookCover
    self.book = book
  }

  var hasChanged: Bool {
    book.title != title
      || book.author != author
      || book.dateAdded != dateAdded
      || book.dateStarted != dateStarted
      || book.dateCompleted != dateCompleted
      || book.synopsis != synopsis
      || book.rating != rating
      || book.status != status.rawValue
      || book.recommendedBy != recommendedBy
      || book.genres != genres
      || book.bookCover != selectedBookCoverData
  }

  func updateBook() {
    book.title = title
    book.author = author
    book.dateAdded = dateAdded
    book.dateStarted = dateStarted
    book.dateCompleted = dateCompleted
    book.synopsis = synopsis
    book.rating = rating
    book.status = status.rawValue
    book.recommendedBy = recommendedBy
    book.quotes = quotes
    book.genres = genres
    book.bookCover = selectedBookCoverData
  }

  func setNewStatus(_ newStatus: Status, _ oldStatus: Status) {
    switch newStatus {
    case .onShelf:
      dateStarted = .distantPast
      dateCompleted = .distantPast
    case .inProgress:
      if oldStatus == .completed {
        dateCompleted = .distantPast
      } else if oldStatus == .onShelf {
        dateStarted = .now
      }
    case .completed:
      if oldStatus == .onShelf {
        dateStarted = dateAdded
      }
      dateCompleted = .now
    }
  }
}
