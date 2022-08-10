//
//  LikeManager.swift
//  myDream
//
//  Created by Cihat Tascı on 9.08.2022.
//

import Foundation
import Firebase

class LikeManager: ObservableObject{
    @Published var like: Like = Like(docID: "", id: "", dreamId: "")
    @Published var isLiked: Bool = false
    @Published var alert: Bool = false
    @Published var alertType: String = "success"
    @Published var alertMessage: String = ""
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore().collection("likes")
    private let dreamDB = Firestore.firestore().collection("dreams")
    
    func likeDream(dream: Dream){
        db.addDocument(data: ["id": user?.uid ?? "", "dreamId": dream.docID, "createdAt": FirebaseFirestore.FieldValue.serverTimestamp()]){error in
            if error != nil{
                self.alert = true
                self.alertType = "error"
                self.alertMessage = "Bir şeyler yanlış gitti :("
            } else{
                self.dreamDB.document(dream.docID).updateData(["likeCount": FieldValue.increment(Int64(1))]){error in
                    if error != nil{
                        self.isLiked = false
                        self.alert = true
                        self.alertType = "error"
                        self.alertMessage = "Bir şeyler yanlış gitti :("
                    } else{
                        self.isLiked = true
                        self.fetchDreamLike(dream: dream)
                    }
                }
            }
        }
    }
    
    func unLikeDream(dream: Dream){
        db.document(self.like.docID).delete(){error in
            if error != nil{
                self.isLiked = true
                self.alert = true
                self.alertType = "error"
                self.alertMessage = "Bir şeyler yanlış gitti :("
            } else{
                self.dreamDB.document(dream.docID).updateData(["likeCount": FieldValue.increment(Int64(-1))]){error in
                    if error != nil{
                        self.isLiked = true
                        self.alert = true
                        self.alertType = "error"
                        self.alertMessage = "Bir şeyler yanlış gitti :("
                    } else{
                        self.isLiked = false
                    }
                }
            }
        }
    }
    
    func fetchDreamLike(dream: Dream){
        db.whereField("dreamId", isEqualTo: dream.docID).whereField("id", isEqualTo: user?.uid ?? "").getDocuments { snapshot, error in
            if error != nil{
                self.isLiked = false
            } else{
                guard let documents = snapshot?.documents else {
                    print("No Like returns..")
                    return
                }
                let like = documents.map({ doc -> Like in
                    let data = doc.data()
                    let id = data["id"] as? String ?? ""
                    let dreamId = data["dreamId"] as? String ?? ""
                    let docId = doc.documentID
                    return Like(docID: docId, id: id, dreamId: dreamId)
                })
                
                self.isLiked = like.count != 0
                if like.count != 0{
                    self.like = like[0]
                }
            }
        }
    }
}
