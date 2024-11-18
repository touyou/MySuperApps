import Foundation

enum Support {
  static func sortBy<M>(_ sortBy: SortDescriptor<M>?...) -> [SortDescriptor<M>] {
    sortBy.compactMap { $0 }
  }
}
