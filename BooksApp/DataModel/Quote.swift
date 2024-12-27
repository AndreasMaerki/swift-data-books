import Foundation
import SwiftData

@Model
class Quote {
  var creationDate = Date.now
  var text: String
  var page: String?
  var book: Book?

  init(text: String, page: String? = nil) {
    self.text = text
    self.page = page
  }
}
