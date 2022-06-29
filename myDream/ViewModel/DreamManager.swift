//
//  UploadManager.swift
//  myDream
//
//  Created by Cihat Tascı on 27.06.2022.
//

import Foundation
import Firebase

class DreamManager: ObservableObject{
    @Published var dreams = [Dream]()
    private let user = Auth.auth().currentUser
    
    func fetchAllDreams(){
        Firestore.firestore().collection("dreams").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print ("no docs returned!")
                return
            }
            
            self.dreams = documents.map({ docSnapshot -> Dream in
                let data = docSnapshot.data()
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                return Dream(id: id, title: title, description: description)
            })
        }
    }
}
