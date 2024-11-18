//
//  MySuperAppsApp.swift
//  MySuperApps
//
//  Created by lease-emp-mac-yosuke-fujii on 2024/03/24.
//

import SwiftUI
import SwiftData
import AppFeature
import Database

@main
struct MySuperAppsApp: App {
    var body: some Scene {
        WindowGroup {
          AppView(store: .init(initialState: .init(), reducer: AppReducer.init))
        }
        .windowResizability(.contentSize)
        #if os(visionOS)
        ImmersiveSpace(id: "ImmersiveSpace") {
            EmptyView()
        }
        #endif
    }
}
