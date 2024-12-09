import SwiftUI

struct NewBookView: View {
  @Environment(\.modelContext) var context
  @Environment(\.dismiss) var dismiss

  @State private var title: String = ""
  @State private var author: String = ""
  var body: some View {
    NavigationStack {
      Form {
        TextField("Title", text: $title)
        TextField("Author", text: $author)
        Button("Create") {
          let book = Book(title: title, author: author)
          context.insert(book)
          dismiss()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .buttonStyle(.borderedProminent)
        .padding(.vertical)
        .disabled(title.isEmpty || author.isEmpty)
      }
      .navigationTitle("New Book")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem {
          Button("Cancel") { dismiss() }
        }
      }
    }
  }
}

#Preview {
  NewBookView()
}
