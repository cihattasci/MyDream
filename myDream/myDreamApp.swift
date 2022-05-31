//
//  myDreamApp.swift
//  myDream
//
//  Created by Cihat Tascı on 31.05.2022.
//

import SwiftUI

@main
struct myDreamApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
