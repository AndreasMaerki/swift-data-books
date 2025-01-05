import SwiftUI

struct EditBookView: View {
  @EnvironmentObject private var viewModel: EditBookViewModel
  var body: some View {
    VStack {
      statusSelector
      VStack {
        boxContent
          .foregroundStyle(.secondary)
          .onChange(of: viewModel.status) { oldStatus, newStatus in
            viewModel.setNewStatus(newStatus, oldStatus)
          }
        Divider()
        titleDetails
      }
    }
    .padding()
    .textFieldStyle(.roundedBorder)
    .navigationTitle(viewModel.title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if viewModel.hasChanged {
        Button("Save") { viewModel.updateBook() }
          .buttonStyle(.borderedProminent)
      }
    }
  }

  private var statusSelector: some View {
    HStack {
      Text("Status")
      Spacer()
      Picker("Status", selection: $viewModel.status) {
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
      switch viewModel.status {
      case .onShelf:
        LabeledContent {
          DatePicker("", selection: $viewModel.dateAdded, displayedComponents: .date)
        } label: {
          Text("Date Added")
        }
      case .inProgress:
        LabeledContent {
          DatePicker("", selection: $viewModel.dateStarted, in: viewModel.dateAdded..., displayedComponents: .date)
        } label: {
          Text("Date Started")
        }
      case .completed:
        LabeledContent {
          DatePicker("", selection: $viewModel.dateCompleted, in: viewModel.dateStarted..., displayedComponents: .date)
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
          RatingsView(maxRating: 5, currentRating: $viewModel.rating)
        } label: {
          Text("Rating:")
        }
        LabeledContent {
          TextField("", text: $viewModel.title)
        } label: {
          Text("Title:")
            .foregroundStyle(.secondary)
            .frame(minWidth: 70, alignment: .leading)
        }
        LabeledContent {
          TextField("", text: $viewModel.author)
        } label: {
          Text("Author:")
            .foregroundStyle(.secondary)
            .frame(minWidth: 70, alignment: .leading)
        }
        LabeledContent {
          TextField("", text: $viewModel.recommendedBy)
        } label: {
          Text("Recommended by:")
            .foregroundStyle(.secondary)
            .frame(minWidth: 70, alignment: .leading)
        }
        Divider()
        Text("Synopsis:")
          .foregroundStyle(.secondary)
        TextEditor(text: $viewModel.synopsis)
          .padding(4)
          .overlay {
            RoundedRectangle(cornerRadius: 20)
              .stroke(style: StrokeStyle(lineWidth: 0.4))
              .foregroundStyle(.tertiary)
          }
        HStack {
          NavigationLink {
            GenresView()
              .environmentObject(viewModel)
          } label: {
            Label("Genre", systemImage: "bookmark.fill")
          }

          NavigationLink {
            QuoteListView()
              .environmentObject(viewModel)
          } label: {
            let count = viewModel.quotes?.count ?? 0
            Label("^[\(count) Quotes](inflect: true)", systemImage: "plus.circle.fill")
          }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .buttonStyle(.bordered)
      }
    }
  }
}

#Preview {
  let preview = Preview(Book.self)
  return NavigationStack {
    EditBookView()
      .modelContainer(preview.container)
      .environmentObject(EditBookViewModel(book: Book.MOCK.first!))
  }
}
