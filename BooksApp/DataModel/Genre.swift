import SwiftData
import SwiftUI

@Model
class Genre {
  var name: String
  var color: String
  var books: [Book]?

  init(name: String, color: String) {
    self.name = name
    self.color = color
  }

  var hexColor: Color {
    Color(hex: color) ?? .red
  }
}

extension Genre {
  static let MOCK: [Genre] = [
    Genre(name: "Fantasy", color: "#6A5ACD"), // SlateBlue
    Genre(name: "Science Fiction", color: "#00CED1"), // DarkTurquoise
    Genre(name: "Mystery", color: "#8B008B"), // DarkMagenta
    Genre(name: "Romance", color: "#FF69B4"), // HotPink
    Genre(name: "Horror", color: "#8B0000"), // DarkRed
    Genre(name: "Thriller", color: "#FF4500"), // OrangeRed
    Genre(name: "Historical Fiction", color: "#DAA520"), // GoldenRod
    Genre(name: "Biography", color: "#228B22"), // ForestGreen
    Genre(name: "Self-Help", color: "#4682B4"), // SteelBlue
    Genre(name: "Poetry", color: "#FF6347"), // Tomato
  ]
}
