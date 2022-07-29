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
    @Published var myDreams = [Dream]()
    @Published var loading: Bool = false
    @Published var searchResultTitle = [Dream]()
    @Published var searchResultDescription = [Dream]()
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore().collection("dreams")

    func fetchAllDreams(){
        db.getDocuments { snapshot, error in
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
    
    func fetchMyDreams(){
        db.whereField("id", isEqualTo: user?.uid ?? "").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print ("no my dreams docs returned!")
                return
            }

            self.myDreams = documents.map({ docSnapshot -> Dream in
                let data = docSnapshot.data()
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""

                return Dream(id: id, title: title, description: description)
            })
        }
    }
    
    func searchDream(text: String) {
        db.whereField("title", isEqualTo: text).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("no search result")
                return
            }

            self.searchResultTitle = documents.map({ doc -> Dream in
                let data = doc.data()
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                return Dream(id: id, title: title, description: description)
            })
        }
        
        db.whereField("description", isEqualTo: text).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("no search result")
                return
            }

            self.searchResultDescription = documents.map({ doc -> Dream in
                let data = doc.data()
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                return Dream(id: id, title: title, description: description)
            })
        }
    }
    
    func deleteDream(dream: Dream){
        loading = true
        db.whereField("id", isEqualTo: dream.id).getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else{
                print("no data")
                self.loading = false
                return
            }
            
            docs.map({ doc -> Int in
                let data = doc.data()
                if(dream.id == data["id"] as! String && dream.description == data["description"] as! String && dream.title == data["title"] as! String){
                    self.db.document(doc.documentID).delete(){ err in
                        if let error = err {
                            print("Silinemedi: \(error.localizedDescription)")
                            self.loading = false
                            return
                        }
                    }
                    self.loading = false
                    return 1
                } else{
                    self.loading = false
                    return 0
                }
            })
        }
    }
}
