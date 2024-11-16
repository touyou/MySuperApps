//
//  MySuperAppsApp.swift
//  MySuperApps
//
//  Created by lease-emp-mac-yosuke-fujii on 2024/03/24.
//

import SwiftUI
import SwiftData
import AppFeature
import SharedModels

@main
struct MySuperAppsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
          AppView(store: .init(initialState: .init(), reducer: AppReducer.init))
        }
        .modelContainer(sharedModelContainer)
        .windowResizability(.contentSize)
        #if os(visionOS)
        ImmersiveSpace(id: "ImmersiveSpace") {
            EmptyView()
        }
        #endif
    }
}
