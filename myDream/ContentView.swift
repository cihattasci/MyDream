//
//  ContentView.swift
//  myDream
//
//  Created by Cihat Tascı on 31.05.2022.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @ObservedObject var auth = AuthManager()

    var body: some View {
        if auth.loading{
            ProgressView()
        } else{
            if auth.session{
                Main()
            } else{
                SignUpScreen()
            }
        }
    }

}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
