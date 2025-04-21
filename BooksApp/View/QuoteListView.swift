import SwiftUI

struct QuoteListView: View {
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject private var viewModel: EditBookViewModel

  @State private var text = ""
  @State private var page = ""
  @State private var selectedQuote: Quote?

  private var isEditing: Bool {
    selectedQuote != nil
  }

  var body: some View {
    VStack {
      quoteBox
        .padding()

      quotesList
    }
    .navigationTitle("Quotes")
  }

  private var quoteBox: some View {
    GroupBox {
      HStack {
        LabeledContent("Page") {
          TextField("Page #", text: $page)
            .autocorrectionDisabled()
            .padding(4)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay {
              RoundedRectangle(cornerRadius: 4)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundStyle(.quinary.opacity(0.5))
            }
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
            updateQuote()
          } else {
            createQuote()
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(text.isEmpty)
      }
      TextEditor(text: $text)
        .cornerRadius(8)
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay {
          RoundedRectangle(cornerRadius: 8)
            .stroke(style: StrokeStyle(lineWidth: 1))
            .foregroundStyle(.quinary.opacity(0.5))
        }
    }
  }

  private var quotesList: some View {
    List {
      let sortedQuotes = viewModel.quotes?.sorted(
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
        for index in indexSet {
          let quote = sortedQuotes[index]
          if let hasQuote = viewModel.quotes?.contains([quote]), hasQuote {
            modelContext.delete(quote)
          }
        }
      }
    }
    .listStyle(.plain)
  }

  private func updateQuote() {
    selectedQuote?.text = text
    selectedQuote?.page = page.isEmpty ? nil : page
    reset()
  }

  private func createQuote() {
    let quote = Quote(text: text, page: page.isEmpty ? nil : page)
    viewModel.quotes?.append(quote)
    viewModel.updateBook()
    reset()
  }

  private func reset() {
    text = ""
    page = ""
    selectedQuote = nil
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  let preview = Preview(Book.self)
  let books = Book.MOCK
  preview.addExamples(books)

  return NavigationStack {
    QuoteListView()
      .environmentObject(EditBookViewModel(book: Book.MOCK.first!))
      .modelContainer(preview.container)
  }
}
