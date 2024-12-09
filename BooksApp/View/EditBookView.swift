import SwiftUI

struct EditBookView: View {
  @State private var title: String
  @State private var author: String
  @State private var dateAdded: Date
  @State private var dateStarted: Date
  @State private var dateCompleted: Date
  @State private var summary: String
  @State private var rating: Int?
  @State private var status: Status
  private let book: Book

  init(book: Book) {
    _title = .init(initialValue: book.title)
    _author = .init(initialValue: book.author)
    _dateAdded = .init(initialValue: book.dateAdded)
    _dateStarted = .init(initialValue: book.dateStarted)
    _dateCompleted = .init(initialValue: book.dateCompleted)
    _summary = .init(initialValue: book.summary)
    _rating = .init(initialValue: book.rating)
    _status = .init(initialValue: book.status)
    self.book = book
  }

  private var hasChanged: Bool {
    book.title != title || book.author != author || book.dateAdded != dateAdded
      || book.dateStarted != dateStarted || book.dateCompleted != dateCompleted
      || book.summary != summary || book.rating != rating
      || book.status != status
  }

  var body: some View {
    VStack {
      statusSelector
      VStack {
        boxContent
          .foregroundStyle(.secondary)
          .onChange(of: status) { oldStatus, newStatus in
            setNewStatus(newStatus, oldStatus)
          }
        Divider()
        titleDetails
      }
    }
    .padding()
    .textFieldStyle(.roundedBorder)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if hasChanged {
        Button("Save") { updateBook() }
          .buttonStyle(.borderedProminent)
      }
    }
  }

  private var statusSelector: some View {
    HStack {
      Text("Status")
      Spacer()
      Picker("Status", selection: $status) {
        ForEach(Status.allCases) { status in
          Text(status.description)
            .tag(status)
        }
      }
      .buttonStyle(.bordered)
      .tint(.primary)
    }
  }

  private var boxContent: some View {
    GroupBox {
      switch status {
      case .onShelf:
        LabeledContent {
          DatePicker("", selection: $dateAdded, displayedComponents: .date)
        } label: {
          Text("Date Added")
        }
      case .inProgress:
        LabeledContent {
          DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
        } label: {
          Text("Date Started")
        }
      case .completed:
        LabeledContent {
          DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
        } label: {
          Text("Date Completed")
        }
      }
    }
  }

  private var titleDetails: some View {
    VStack(alignment: .leading, spacing: 16) {
      Group {
        LabeledContent {
          RatingsView(maxRating: 5, currentRating: $rating)
        } label: {
          Text("Rating:")
        }
        LabeledContent {
          TextField("", text: $title)
        } label: {
          Text("Title:")
            .foregroundStyle(.secondary)
            .frame(minWidth: 70, alignment: .leading)
        }
        LabeledContent {
          TextField("", text: $author)
        } label: {
          Text("Author:")
            .foregroundStyle(.secondary)
            .frame(minWidth: 70, alignment: .leading)
        }
        Divider()
        Text("Summary:")
          .foregroundStyle(.secondary)
        TextEditor(text: $summary)
          .padding(4)
          .overlay {
            RoundedRectangle(cornerRadius: 20)
              .stroke(style: StrokeStyle(lineWidth: 0.4))
              .foregroundStyle(.tertiary)
          }
      }
    }
  }

  private func setNewStatus(_ newStatus: Status, _ oldStatus: Status) {
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

  private func updateBook() {
    book.title = title
    book.author = author
    book.dateAdded = dateAdded
    book.dateStarted = dateStarted
    book.dateCompleted = dateCompleted
    book.summary = summary
    book.rating = rating
    book.status = status
  }
}

#Preview {
  EditBookView(book: Book.MOCK.first!)
}
