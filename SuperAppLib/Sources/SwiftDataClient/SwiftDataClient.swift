// ref: https://github.com/bradhowes/SwiftDataTCA
// これをベースにSwiftDataの機能を作ると良さそう

//import Dependencies
//import DependenciesMacros
//import SharedModels
//import SwiftData
//
//@DependencyClient
//public struct SwiftDataClient : Sendable{
//  var context: () throws -> ModelContext
//}
//
//extension SwiftDataClient: DependencyKey {
//  @MainActor
//  static public let liveValue: SwiftDataClient = Self(context: {
//    appContext
//  })
//}
//
//@MainActor
//let appContext: ModelContext = {
//  let container = {
//    let schema = Schema([
//      Item.self,
//    ])
//    
//    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//    
//    do {
//      return try ModelContainer(for: schema, configurations: [modelConfiguration])
//    } catch {
//      fatalError("Could not create model container: \(error)")
//    }
//  }()
//  
//  let context = ModelContext(container)
//  return context
//}()
