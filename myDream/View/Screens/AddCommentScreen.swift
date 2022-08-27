//
//  AddCommentScreen.swift
//  myDream
//
//  Created by Cihat Tascı on 30.07.2022.
//

import SwiftUI

struct AddCommentScreen: View {
    @State var comment: String = ""
    @ObservedObject var commentViewModel = Commentmanager()
    
    let dream: Dream
    
    let size = UIScreen.main.bounds
    var body: some View {
        if commentViewModel.loading{
            ProgressView("Yükleme Gerçekleştiriliyor..")
        } else{
            VStack{
                VStack {
                    ScrollView(showsIndicators: false){
                        Text(dream.description).padding(EdgeInsets(top: 50, leading: 30, bottom: 0, trailing: 0))
                    }
                }.frame(width: size.width, height: size.height*0.35, alignment: .leading)
                Divider()
                TextField("Rüya yorumunuzu buraya yazınız", text: $comment)
                    .frame(height: size.height*0.43, alignment: .topLeading)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.sentences)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Spacer()
            }
            .alert(isPresented: $commentViewModel.alert){
                if commentViewModel.alertType == "success"{
                    return Alert(title: Text("Başarılı"), message: Text(commentViewModel.alertMessage), dismissButton: .default(Text("Kapat"), action: {
                        self.comment = ""
                    }))
                } else{
                    return Alert(title: Text("Hata"), message: Text(commentViewModel.alertMessage))
                }
            }
            .navigationTitle("Yorum Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        commentViewModel.addCommentToDream(dreamId: dream.id, docID: dream.docID, comment: comment, dream: dream)
                    } label: {
                        Text("Yorumu Ekle").foregroundColor(.blue)
                    }.disabled(comment.isEmpty)
                }
            }
        }
    }
}

struct AddCommentScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddCommentScreen(dream: Dream(docID: "SDASDAS", id: "s", title: "sdfsdf", description: "dfdsf", likeCount: 0, commentCount: 0))
    }
}
