//
//  myDreamApp.swift
//  myDream
//
//  Created by Cihat Tascı on 31.05.2022.
//

import SwiftUI
import Firebase

@main
struct myDreamApp: App {
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
