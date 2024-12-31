import SwiftUI

struct QuoteListView: View {
  @Environment(\.modelContext) private var modelContext
  let book: Book

  @State private var text = ""
  @State private var page = ""
  @State private var selectedQuote: Quote?

  private var isEditing: Bool {
    selectedQuote != nil
  }


  var body: some View {
    quoteBox
      .padding()

    List {
      let sortedQuotes = book.quotes?.sorted(
        using: KeyPathComparator(\Quote.creationDate)
      ) ?? []

      ForEach(sortedQuotes) { quote in
        VStack(alignment: .leading) {
          Text(quote.creationDate, format: .dateTime.day().month().year())
            .font(.caption)
            .foregroundStyle(.secondary)
          Text(quote.text)

          HStack {
            Spacer()
            if let page = quote.page, !page.isEmpty {
              Text("Page: \(page)")
            }
          }
        }
        .contentShape(Rectangle())
        .onTapGesture {
          selectedQuote = quote
          text = quote.text
          page = quote.page ?? ""
        }
      }
      .onDelete { indexSet in
        indexSet.forEach { index in
          if let quote = book.quotes?[index] {
            modelContext.delete(quote)
          }
        }
      }
    }
    .listStyle(.plain)
    .navigationTitle("Quotes")
  }

  private var quoteBox: some View {
    GroupBox {
      HStack {
        LabeledContent("Page") {
          TextField("Page #", text: $page)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .frame(width: 150)
          Spacer()
        }

        if isEditing {
          Button("Cancel") {
            reset()
          }
          .buttonStyle(.bordered)
        }

        Button(isEditing ? "Update" : "Create") {
          if isEditing {
            selectedQuote?.text = text
            selectedQuote?.page = page.isEmpty ? nil : page
            reset()
          } else {
            let quote = Quote(text: text, page: page.isEmpty ? nil : page)
            book.quotes?.append(quote)
            reset()
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(text.isEmpty)
      }
      TextEditor(text: $text)
        .border(.tertiary)
        .frame(height: 100)
    }
  }

  private func reset() {
    text = ""
    page = ""
    selectedQuote = nil
  }
}

#Preview {
  let preview = Preview(Book.self)
  let books = Book.MOCK
  preview.addExamples(books)

  return NavigationStack {
    QuoteListView(book: books[2])
      .modelContainer(preview.container)
  }
}
