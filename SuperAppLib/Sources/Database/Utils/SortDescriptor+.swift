import Foundation

extension SortDescriptor {
  static func sortBy<M, V: Comparable>(_ key: KeyPath<M, V>, order: SortOrder?) -> SortDescriptor<M>? {
    guard let order else { return nil }
    return .init(key, order: order)
  }
}
