//
//  LikeManager.swift
//  myDream
//
//  Created by Cihat Tascı on 9.08.2022.
//

import Foundation
import Firebase

class LikeManager: ObservableObject{
    @Published var like: Like = Like(docID: "", id: "", dreamId: "", dream: Dream(docID: "", id: "", title: "", description: "", likeCount: 0, commentCount: 0))
    @Published var myLikes = [Like]()
    @Published var isLiked: Bool = false
    @Published var alert: Bool = false
    @Published var alertType: String = "success"
    @Published var alertMessage: String = ""
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore().collection("likes")
    private let dreamDB = Firestore.firestore().collection("dreams")
    
    func likeDream(dream: Dream){
        db.addDocument(data: ["id": user?.uid ?? "", "dreamId": dream.docID, "dreamDocId": dream.docID, "dreamTitle": dream.title, "dreamDescription": dream.description, "dreamLikeCount": dream.likeCount + 1, "dreamCommentCount": dream.commentCount, "createdAt": FirebaseFirestore.FieldValue.serverTimestamp()]){error in
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
                    let dreamTitle = data["dreamTitle"] as? String ?? ""
                    let dreamDescription = data["dreamDescription"] as? String ?? ""
                    let dreamLikeCount = data["dreamLikeCount"] as? Int ?? 0
                    let dreamCommentCount = data["dreamCommentCount"] as? Int ?? 0
                    let docId = doc.documentID
                    return Like(docID: docId, id: id, dreamId: dreamId, dream: Dream(docID: docId, id: dreamId, title: dreamTitle, description: dreamDescription, likeCount: dreamLikeCount, commentCount: dreamCommentCount))
                })
                
                self.isLiked = like.count != 0
                if like.count != 0{
                    self.like = like[0]
                }
            }
        }
    }
    
    func fetchMyLikes(){
        db.whereField("id", isEqualTo: user?.uid ?? "").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("no likes")
                return
            }
            
            let myLikes = documents.map { snap -> Like in
                let data = snap.data()
                let id = data["id"] as? String ?? ""
                let docId = data["dreamDocId"] as? String ?? ""
                let dreamId = data["dreamId"] as? String ?? ""
                let dreamTitle = data["dreamTitle"] as? String ?? ""
                let dreamDescription = data["dreamDescription"] as? String ?? ""
                let dreamLikeCount = data["dreamLikeCount"] as? Int ?? 0
                let dreamCommentCount = data["dreamCommentCount"] as? Int ?? 0
                
                return Like(docID: docId, id: id, dreamId: dreamId, dream: Dream(docID: docId, id: dreamId, title: dreamTitle, description: dreamDescription, likeCount: dreamLikeCount, commentCount: dreamCommentCount))
            }
            
            self.myLikes = myLikes
        }
    }
}
