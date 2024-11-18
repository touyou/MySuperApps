// ref: https://github.com/bradhowes/SwiftDataTCA
import Dependencies
import Foundation
import SwiftData

struct Database {
  var fetchItems: @Sendable (FetchDescriptor<ItemModel>) -> [ItemModel]
  var add: @Sendable () -> ItemModel
  var delete: @Sendable (ItemModel) -> Void
  var save: @Sendable () -> Void
}

@Sendable
private func doFetchItem(_ descriptor: FetchDescriptor<ItemModel>) -> [ItemModel] {
  @Dependency(\.modelContextProvider) var context
  return (try? context.fetch(descriptor)) ?? []
}

@Sendable
private func doAdd() -> ItemModel {
  @Dependency(\.modelContextProvider) var context
  return ActiveSchema.makeItem(context: context, title: "")
}

@Sendable
private func doDelete(_ item: ItemModel) {
  @Dependency(\.modelContextProvider) var context
  do {
    try ActiveSchema.deleteItem(context, item: item)
  } catch {
    fatalError("Encountered failure while deleting itemModel - \(error)")
  }
}

@Sendable
private func doSave() {
  @Dependency(\.modelContextProvider) var context
  try? context.save()
}

extension DependencyValues {
  var database: Database {
    get { self[Database.self] }
    set { self[Database.self] = newValue }
  }
}

extension Database: DependencyKey {
  static let liveValue = Self(
    fetchItems: doFetchItem,
    add: doAdd,
    delete: doDelete,
    save: doSave
  )
}
