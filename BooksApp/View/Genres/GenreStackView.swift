import SwiftUI

struct GenreStackView: View {
  var genres: [Genre]
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(genres.sorted(using: KeyPathComparator(\Genre.name))) { genre in
          Text(genre.name)
            .font(.caption)
            .foregroundStyle(.white)
            .padding(4)
            .background {
              RoundedRectangle(cornerRadius: 4)
                .fill(genre.hexColor)
            }
        }
      }
    }
  }
}

#Preview {
  GenreStackView(genres: Genre.MOCK)
}
