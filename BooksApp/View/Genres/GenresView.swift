import SwiftData
import SwiftUI

struct GenresView: View {
  @Environment(\.modelContext) private var context
  @EnvironmentObject private var viewModel: EditBookViewModel

  @Query(sort: \Genre.name) var genres: [Genre]
  @State var createNewGenre = false

  var body: some View {
    Group {
      if genres.isEmpty {
        contentUnavailable
      } else {
        genreList
      }
    }
    .navigationTitle(viewModel.title)
    .sheet(isPresented: $createNewGenre) {
      NewGenreView()
    }
  }

  private var contentUnavailable: some View {
    ContentUnavailableView {
      Image(systemName: "bookmark.fill")
    } description: {
      Text("You need to create some genres first.")
    } actions: {
      Button("Create Genre") {
        createNewGenre.toggle()
      }
      .buttonStyle(.borderedProminent)
    }
  }

  private var genreList: some View {
    List {
      ForEach(genres) { genre in
        HStack {
          if let bookGenres = viewModel.genres {
            if bookGenres.isEmpty {
              Button {
                addRemove(genre)
              } label: {
                Image(systemName: "circle")
              }
              .foregroundStyle(genre.hexColor)
            } else {
              Button {
                addRemove(genre)
              } label: {
                Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
              }
              .foregroundStyle(genre.hexColor)
            }
          }
          Text(genre.name)
        }
      }
      LabeledContent {
        Button {
          createNewGenre.toggle()
        } label: {
          Image(systemName: "plus.circle.fill")
            .imageScale(.large)
        }
        .buttonStyle(.borderedProminent)
      } label: {
        Text("Create new Genre")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .listStyle(.plain)
  }

  private func addRemove(_ genre: Genre) {
    guard var bookGenres = viewModel.genres else {
      viewModel.genres = [genre]
      return
    }
    if bookGenres.contains(genre),
       let index = bookGenres.firstIndex(where: { $0.id == genre.id })
    {
      bookGenres.remove(at: index)
    } else {
      bookGenres.append(genre)
    }
    viewModel.genres = bookGenres
  }
}

#Preview {
  let preview = Preview(Book.self)
  let genres = Genre.MOCK
  let books = Book.MOCK
  preview.addExamples(books)
  preview.addExamples(genres)
  books[1].genres = [genres[0]]
  return NavigationStack { GenresView()
    .modelContainer(preview.container)
    .environmentObject(EditBookViewModel(book: books[1]))
  }
}
