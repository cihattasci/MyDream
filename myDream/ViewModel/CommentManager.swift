//
//  CommentManager.swift
//  myDream
//
//  Created by Cihat Tascı on 6.08.2022.
//

import Foundation
import Firebase

class Commentmanager: ObservableObject{
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore().collection("comments")
    private let dreamDB = Firestore.firestore().collection("dreams")
    
    @Published var loading: Bool = false
    @Published var alert: Bool = false
    @Published var alertType: String = "success"
    @Published var alertMessage: String = ""
    @Published var dreamComments = [Comment]()
    @Published var myComments = [Comment]()
    
    func addCommentToDream(dreamId: String, docID: String, comment: String, dream: Dream){
        loading = true
        db.addDocument(data: ["id": user?.uid ?? "", "dreamId": dreamId, "comment": comment, "createdAt": FirebaseFirestore.FieldValue.serverTimestamp(), "dreamDocId": dream.docID, "dreamTitle": dream.title, "dreamDescription": dream.description, "dreamLikeCount": dream.likeCount, "dreamCommentCount": dream.commentCount + 1]) {error in
            if error == nil{
                self.dreamDB.document("\(docID)").updateData(["commentCount": FieldValue.increment(Int64(1))]){err in
                    if err == nil{
                        self.loading = false
                        self.alert = true
                        self.alertType = "success"
                        self.alertMessage = "Yorumunuz başarıyla yüklendi"
                    } else{
                        self.loading = false
                        self.alert = true
                        self.alertType = "error"
                        self.alertMessage = "Yorum yüklendi fakat hata meydana geldi :("
                    }
                }
            } else{
                self.loading = false
                self.alert = true
                self.alertType = "error"
                self.alertMessage = "Yorum Yüklenemedi"
            }
        }
    }
    
    func fetchCommentOfDream(dreamId: String){
        self.loading = true
        db.whereField("dreamId", isEqualTo: dreamId).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print ("no comment docs returned!")
                return
            }
            
            self.dreamComments = documents.map({ doc -> Comment in
                let data = doc.data()
                let docId = doc.documentID
                let id = data["id"] as? String ?? ""
                let dreamId = data["dreamId"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let dreamTitle = data["dreamTitle"] as? String ?? ""
                let dreamDescription = data["dreamDescription"] as? String ?? ""
                let dreamLikeCount = data["dreamLikeCount"] as? Int ?? 0
                let dreamCommentCount = data["dreamCommentCount"] as? Int ?? 0
                
                return Comment(docID: docId, id: id, dreamId: dreamId, comment: comment, dream: Dream(docID: docId, id: dreamId, title: dreamTitle, description: dreamDescription, likeCount: dreamLikeCount, commentCount: dreamCommentCount))
            })
            
            self.loading = false
        }
    }
    
    func deleteComment(docID: String, dreamDocId: String){
        self.loading = true
        db.document(docID).delete(){error in
            if error != nil{
                self.alertType = "error"
                self.alertMessage = "Bir hata oluştu"
            } else{
                self.alertType = "success"
                self.alertMessage = "Yorumunuz Silindi"
                let indexOfComment = self.dreamComments.firstIndex(where: {$0.docID == docID})
                if let indexOfComment = indexOfComment{
                    self.dreamComments.remove(at: indexOfComment)
                    self.dreamDB.document(dreamDocId).updateData(["commentCount" : FieldValue.increment(-Int64(1))])
                }
            }
            self.loading = false
            self.alert = true
        }
    }
    
    func updateComment(comment: Comment, newComment: String){
        self.db.document(comment.docID).updateData(["comment": newComment]){error in
            if error != nil{
                self.alert = true
                self.alertType = "error"
                self.alertMessage = "Bir hata oluştu"
            } else{
                self.alert = true
                self.alertType = "success"
                self.alertMessage = "Yorumunuz Güncellendi"
                let indexOfComment = self.dreamComments.firstIndex(where: {$0.docID == comment.docID})
                if let indexOfComment = indexOfComment{
                    self.dreamComments[indexOfComment].comment = newComment
                }
            }
        }
    }
    
    func getMyComments(){
        db.whereField("id", isEqualTo: user?.uid ?? "").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("no likes")
                return
            }
            
            let myComments = documents.map { snap -> Comment in
                let data = snap.data()
                let id = data["id"] as? String ?? ""
                let docId = data["dreamDocId"] as? String ?? ""
                let dreamId = data["dreamId"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let dreamTitle = data["dreamTitle"] as? String ?? ""
                let dreamDescription = data["dreamDescription"] as? String ?? ""
                let dreamLikeCount = data["dreamLikeCount"] as? Int ?? 0
                let dreamCommentCount = data["dreamCommentCount"] as? Int ?? 0
                
                return Comment(docID: docId, id: id, dreamId: dreamId, comment: comment, dream: Dream(docID: docId, id: dreamId, title: dreamTitle, description: dreamDescription, likeCount: dreamLikeCount, commentCount: dreamCommentCount))
            }
            
            self.myComments = myComments
        }
    }
}
