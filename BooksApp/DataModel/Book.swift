import SwiftData
import SwiftUI

@Model
class Book: Hashable {
  @Attribute(.unique)
  var title: String

  var author: String
  var dateAdded: Date
  var dateStarted: Date
  var dateCompleted: Date
  // the attribute allows SwiftData to performa lightweight migration.
  @Attribute(originalName: "summary")
  var synopsis: String
  var rating: Int?
  var status: Status.RawValue
  // by initialising a new property right away we allow SwiftData
  // to perform a lightweight migration automatically
  var recommendedBy: String = ""

  init(
    title: String,
    author: String,
    dateAdded: Date = Date.now,
    dateStarted: Date = .distantPast,
    dateCompleted: Date = .distantPast,
    synopsis: String = "",
    rating: Int? = nil,
    status: Status = .onShelf,
    recommendedBy: String = ""
  ) {
    self.title = title
    self.author = author
    self.dateAdded = dateAdded
    self.dateStarted = dateStarted
    self.dateCompleted = dateCompleted
    self.synopsis = synopsis
    self.rating = rating
    self.status = status.rawValue
    self.recommendedBy = recommendedBy
  }
}

extension Book {
  var icon: Image {
    switch Status(rawValue: status)! {
    case .onShelf:
      Image(systemName: "checkmark.diamond.fill")
    case .inProgress:
      Image(systemName: "book.fill")
    case .completed:
      Image(systemName: "books.vertical.fill")
    }
  }
}

extension Book {
  // mock data all varaibles
  static let MOCK: [Book] = [
    Book(
      title: "1984",
      author: "George Orwell",
      dateAdded: Date(timeIntervalSince1970: 1_609_459_200), // December 25, 2020
      dateStarted: Date(timeIntervalSince1970: 1_610_064_000), // January 1, 2021
      dateCompleted: Date(timeIntervalSince1970: 1_612_841_600), // February 28, 2021
      synopsis: "A dystopian novel about totalitarianism and surveillance.",
      rating: 5,
      status: .completed,
      recommendedBy: "Friend"
    ),

    Book(
      title: "To Kill a Mockingbird",
      author: "Harper Lee",
      dateAdded: Date(timeIntervalSince1970: 1_612_150_400), // February 1, 2021
      dateStarted: Date(timeIntervalSince1970: 1_614_928_000), // March 1, 2021
      dateCompleted: Date.distantPast, // Not completed yet
      synopsis: "A story about racial injustice and moral growth.",
      rating: nil,
      status: .inProgress,
      recommendedBy: ""
    ),

    Book(
      title: "Pride and Prejudice",
      author: "Jane Austen",
      dateAdded: Date(timeIntervalSince1970: 1_617_612_800), // April 1, 2021
      dateStarted: Date.distantPast, // Not started yet
      dateCompleted: Date.distantPast,
      synopsis: "A classic romance novel exploring social status and marriage.",
      rating: nil,
      status: .onShelf,
      recommendedBy: "Friend 2"
    ),

    Book(
      title: "The Great Gatsby",
      author: "F. Scott Fitzgerald",
      dateAdded: Date(timeIntervalSince1970: 1_619_859_200), // May 1, 2021
      dateStarted: Date(timeIntervalSince1970: 1_620_032_000), // May 3, 2021
      dateCompleted: Date(timeIntervalSince1970: 1_620_377_600), // May 7, 2021
      synopsis: "Set in the Jazz Age, it explores themes of decadence and excess.",
      rating: 4,
      status: .completed,
      recommendedBy: ""
    ),

    Book(
      title: "Sapiens",
      author: "Yuval Noah Harari",
      dateAdded: Date(timeIntervalSince1970: 1_625_097_600), // July 1, 2021
      dateStarted: Date(timeIntervalSince1970: 1_625_356_800), // July 4, 2021
      dateCompleted: Date.distantPast, // Not completed yet
      synopsis: "A history of human evolution and cultural development.",
      rating: nil,
      status: .inProgress,
      recommendedBy: "Friend 3"
    ),
  ]
}

enum Status: Int, Codable, Identifiable, CaseIterable {
  case onShelf
  case inProgress
  case completed

  var id: Self {
    self
  }

  var description: String {
    switch self {
    case .onShelf:
      "on shelf"
    case .inProgress:
      "in progress"
    case .completed:
      "completed"
    }
  }
}
