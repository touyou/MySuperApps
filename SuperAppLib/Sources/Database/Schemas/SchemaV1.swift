import Foundation
import SwiftData
import Dependencies

public enum SchemaV1: VersionedSchema {
  public static var versionIdentifier: Schema.Version { .init(1, 0, 0) }
  
  public static var models: [any PersistentModel.Type] {
    [ItemModel.self]
  }
  
  @Model
  public final class ItemModel {
    public var title: String
    public var isDone: Bool
    public var createdAt: Date
    
    var valueType: Item { .init(modelId: persistentModelID, title: title, isDone: isDone, createdAt: createdAt) }
    
    public init(title: String) {
      self.title = title
      self.isDone = false
      self.createdAt = .now
    }
  }
  
  public struct Item {
    let modelId: PersistentIdentifier
    let title: String
    let isDone: Bool
    let createdAt: Date
    
    @discardableResult
    func backingObject(performing: ((ItemModel) -> Void)? = nil) -> ItemModel {
      @Dependency(\.modelContextProvider) var context
      guard let item = context.model(for: modelId) as? ItemModel else {
        fatalError("Faied to resolve \(self.title) using \(self.modelId)")
      }
      
      if let performing {
        performing(item)
        try? context.save()
      }
      
      return item
    }
  }
}

extension SchemaV1.Item: Identifiable {
  public var id: PersistentIdentifier { modelId }
}

extension SchemaV1.Item: Equatable {
  static public func == (lhs: SchemaV1.Item, rhs: SchemaV1.Item) -> Bool {
    lhs.id == rhs.id && lhs.isDone == rhs.isDone && lhs.createdAt == rhs.createdAt
  }
}

extension SchemaV1.Item: Sendable {}

extension SchemaV1 {
  @discardableResult
  static func makeItem(context: ModelContext, title: String) -> ItemModel {
    let item = ItemModel(title: title)
    context.insert(item)
    
    try? context.save()
    
    return item
  }
  
  @inlinable
  static func searchPredicate(_ search: String) -> Predicate<ItemModel>? {
    search.isEmpty ? nil : #Predicate<ItemModel> { $0.title.localizedStandardContains(search) }
  }
  
  static func itemFetchDescriptor(createdAtSort: SortOrder? = .forward, search: String = "") -> FetchDescriptor<ItemModel> {
    let sortBy: [SortDescriptor<ItemModel>] = Support.sortBy(.sortBy(\ItemModel.createdAt, order: createdAtSort))
    let fetchDescriptor = FetchDescriptor(predicate: searchPredicate(search), sortBy: sortBy)
    return fetchDescriptor
  }
  
  static func deleteItem(_ context: ModelContext, item: ItemModel) throws {
    context.delete(item)
    try context.save()
  }
}
