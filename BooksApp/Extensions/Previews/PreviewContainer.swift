import Foundation
import SwiftData

struct Preview {
  let container: ModelContainer
  // inject model in form of a variadic argument.
  init(_ models: any PersistentModel.Type...) {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema(models)
    do {
      container = try ModelContainer(for: schema, configurations: config)
    } catch {
      fatalError("could not create preview container.")
    }
  }

  func addExamples(_ examples: [any PersistentModel]) {
    Task { @MainActor in
      examples.forEach { container.mainContext.insert($0) }
    }
  }
}
