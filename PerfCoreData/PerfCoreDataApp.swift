//
//  PerfCoreDataApp.swift
//  PerfCoreData
//
//  Created by Uhl Albert on 8/19/24.
//

import SwiftUI

@main
struct PerfCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
