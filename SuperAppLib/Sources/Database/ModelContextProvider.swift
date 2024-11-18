import Dependencies
import Foundation
import SwiftData

typealias ActiveSchema = SchemaV1

typealias ItemModel = ActiveSchema.ItemModel
typealias Item = ActiveSchema.Item

public struct ModelContextProvider {
  public let context: ModelContext
}

extension DependencyValues {
  public var modelContextProvider: ModelContext {
    get { self[ModelContextKey.self] }
    set { self[ModelContextKey.self] = newValue }
  }
}

public enum ModelContextKey: DependencyKey {
  public static let liveValue = liveContext()
}

func makeLiveContainer(dbFile: URL) -> ModelContainer {
  let schema = Schema(versionedSchema: ActiveSchema.self)
  let config = ModelConfiguration(schema: schema, url: dbFile, cloudKitDatabase: .none)
  return try! ModelContainer(for: schema, migrationPlan: nil, configurations: config)
}

private let liveContainer: ModelContainer = makeLiveContainer(
  dbFile: URL.applicationSupportDirectory.appending(path: "Models.sqlite")
)

@MainActor internal let liveContext: (() -> ModelContext) = {
  return liveContainer.mainContext
}

// NOTE: Sendable
#if hasFeature(RetroactiveAttribute)
extension KeyPath: @unchecked @retroactive Sendable {}
extension ModelContext: @unchecked @retroactive Sendable {}
#else
extension KeyPath: @unchecked Sendable {}
extension ModelContext: @unchecked Sendable {}
#endif

// NOTE:テスト用

extension ModelContextKey: TestDependencyKey {
  public static var previewValue: ModelContext { previewContext() }
  public static var testValue: ModelContext {
    unimplemented("ModelContextProvider testValue", placeholder: ModelContextKey.testValue)
  }
}

/// テスト用のコンテキストを作る
internal func makeTestContext(mockCount: Int = 0) throws -> ModelContext {
  try makeMockContext(mockCount: mockCount)
}

/// モックを生成する
internal func makeMockContext(mockCount: Int) throws -> ModelContext {
  let context = try ModelContext(makeInMemoryContainer())
  // TODO: generate mock
  return context
}

/// メモリ上での保存にする
internal func makeInMemoryContainer() throws -> ModelContainer {
  let schema = Schema(versionedSchema: ActiveSchema.self)
  let config = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: true,
    groupContainer: .none,
    cloudKitDatabase: .none
  )
  return try ModelContainer(for: schema, migrationPlan: nil, configurations: config)
}

/// プレビュー用のコンテキスト
@MainActor private let previewContext: (() -> ModelContext) = {
  makeContext(mockCount: 32)
}

/// コンテキストを作る
@MainActor private func makeContext(mockCount: Int) -> ModelContext {
  try! makeMockContext(mockCount: mockCount)
}
