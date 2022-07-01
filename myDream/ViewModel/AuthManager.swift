//
//  AuthManager.swift
//  myDream
//
//  Created by Cihat Tascı on 26.06.2022.
//

import Foundation
import Firebase

class AuthManager: ObservableObject{
    @Published var session: Bool = false
    @Published var loading: Bool = true
    
    init(){
        Auth.auth().addStateDidChangeListener { auth, user in
            self.loading = false
            self.session = user != nil
        }
    }
}
