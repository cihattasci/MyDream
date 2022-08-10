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
    @Published var isLiked: Bool = false
    @Published var alert: Bool = false
    @Published var alertType: String = "success"
    @Published var alertMessage: String = ""
    @Published var searchResultTitle = [Dream]()
    @Published var searchResultDescription = [Dream]()
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore().collection("dreams")

    func fetchAllDreams(){
        self.loading = true
        db.order(by: "createdAt", descending: true).limit(to: 15).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print ("no docs returned!")
                self.loading = false
                return
            }

            self.dreams = documents.map({ docSnapshot -> Dream in
                let data = docSnapshot.data()
                let docID = docSnapshot.documentID
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let likeCount = data["likeCount"] as? Int ?? 0
                let commentCount = data["commentCount"] as? Int ?? 0

                return Dream(docID: docID, id: id, title: title, description: description, likeCount: likeCount, commentCount: commentCount)
            })
            
            self.loading = false
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
                let docID = docSnapshot.documentID
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let likeCount = data["likeCount"] as? Int ?? 0
                let commentCount = data["commentCount"] as? Int ?? 0

                return Dream(docID: docID, id: id, title: title, description: description, likeCount: likeCount, commentCount: commentCount)
            })
        }
    }
    
    func searchDream(text: String) {
        db.whereField("title", isEqualTo: text).limit(to: 5).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("no search result")
                return
            }

            self.searchResultTitle = documents.map({ doc -> Dream in
                let data = doc.data()
                let docID = doc.documentID
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let likeCount = data["likeCount"] as? Int ?? 0
                let commentCount = data["commentCount"] as? Int ?? 0

                return Dream(docID: docID, id: id, title: title, description: description, likeCount: likeCount, commentCount: commentCount)
            })
        }
        
        db.whereField("description", isEqualTo: text).limit(to: 5).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("no search result")
                return
            }

            self.searchResultDescription = documents.map({ doc -> Dream in
                let data = doc.data()
                let docID = doc.documentID
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let likeCount = data["likeCount"] as? Int ?? 0
                let commentCount = data["commentCount"] as? Int ?? 0

                return Dream(docID: docID, id: id, title: title, description: description, likeCount: likeCount, commentCount: commentCount)
            })
        }
    }
    
    func deleteDream(dream: Dream) {
        loading = true
        db.document(dream.docID).delete(){err in
            if let error = err {
                print("Silinemedi: \(error.localizedDescription)")
            } else{
                let index = self.myDreams.firstIndex(where: {$0.id == dream.id})
                if let index = index{
                    self.myDreams.remove(at: index)
                }
            }
            self.loading = false
        }
    }
}
