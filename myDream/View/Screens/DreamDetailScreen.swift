//
//  DreamDetailScreen.swift
//  myDream
//
//  Created by Cihat Tascı on 1.07.2022.
//

import SwiftUI
import Firebase

struct DreamDetailScreen: View {
    @ObservedObject var commentViewModel = Commentmanager()
    @ObservedObject var likeViewModel = LikeManager()
    
    @State var goToCommentScreen: Bool = false
    @State var showComment: Bool = false
    @State var editCommentSheet: Bool = false
    @State var selectedComment: Comment = Comment(docID: "", id: "", dreamId: "", comment: "", dream: Dream(docID: "", id: "", title: "", description: "", likeCount: 0, commentCount: 0))
    @State var newComment: String = ""
    
    private let user = Auth.auth().currentUser
    private let size = UIScreen.main.bounds
    let dream: Dream
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 0)
                .background(Color(hex: 0x03fcbe))
            if !showComment{
                ScrollView(showsIndicators: false){
                    HStack {
                        Text(dream.title).foregroundColor(.black).font(.title).padding(.all, 20)
                        Spacer()
                    }
                    HStack {
                        Text(dream.description).font(.body)
                        Spacer()
                    }.padding(.horizontal, 20)
                    Spacer()
                }
            } else{
                HStack {
                    Text(dream.title).foregroundColor(.black).font(.title).padding(.all, 20)
                    Spacer()
                }
                HStack {
                    Text(dream.description).font(.body)
                    Spacer()
                }.padding(.horizontal, 20)
                Spacer()
                if showComment{
                    if commentViewModel.loading{
                        ProgressView("İşlem Gerçekleştiriliyor..")
                    } else{
                        List{
                            ForEach(commentViewModel.dreamComments, id: \.self){comment in
                                CommentElement(comment: comment, canEdit: comment.id == user?.uid)
                                    .swipeActions(edge: .trailing, content: {
                                        if comment.id == user?.uid{
                                            Button{
                                                self.editCommentSheet = true
                                                self.selectedComment = comment
                                            } label:{
                                                Label("Düzenle", systemImage: "pencil").foregroundColor(.white)
                                            }
                                            .tint(.blue)
                                        }
                                    })
                                    .swipeActions(edge: .trailing, content: {
                                        if comment.id == user?.uid{
                                            Button{
                                                commentViewModel.deleteComment(docID: comment.docID, dreamDocId: dream.docID)
                                            } label:{
                                                Label("Sil", systemImage: "trash").foregroundColor(.white)
                                            }
                                            .tint(.red)
                                        }
                                    })
                            }
                        }.listStyle(GroupedListStyle())
                            .refreshable {
                                commentViewModel.fetchCommentOfDream(dreamId: dream.id)
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $editCommentSheet, content: {
            VStack{
                Text("Yorumunu Düzenle").font(.title3).padding([.vertical], 10)
                TextField("Yeni yorumunuzu yazın", text: $newComment)
                    .frame(width: size.width*0.95, height: size.height*0.3, alignment: .topLeading)
                    .disableAutocorrection(true)
                    .padding([.vertical], 10)
                Divider()
                Spacer()
                Button {
                    commentViewModel.updateComment(comment: self.selectedComment, newComment: self.newComment)
                    self.editCommentSheet.toggle()
                } label: {
                    Text("Yorumu Güncelle").foregroundColor(.blue).padding([.vertical], 10)
                }.disabled(self.newComment.isEmpty)
                Button {
                    self.editCommentSheet.toggle()
                    self.selectedComment = Comment(docID: "", id: "", dreamId: "", comment: "", dream: Dream(docID: "", id: "", title: "", description: "", likeCount: 0, commentCount: 0))
                    self.newComment = ""
                } label: {
                    Text("Vazgeç").foregroundColor(.red).padding([.vertical], 10)
                }
            }
        })
        .alert(isPresented: $likeViewModel.alert){
            if likeViewModel.alertType == "success"{
                return Alert(title: Text("Başarılı"), message: Text(likeViewModel.alertMessage))
            } else{
                return Alert(title: Text("Hata"), message: Text(likeViewModel.alertMessage))
            }
        }
//        .alert(isPresented: $commentViewModel.alert){
//            if commentViewModel.alertType == "success"{
//                return Alert(title: Text("Başarılı"), message: Text(commentViewModel.alertMessage), dismissButton: .default(Text("Kapat"), action: {
//                    self.editCommentSheet = false
//                    self.newComment = ""
//                }))
//            } else{
//                return Alert(title: Text("Hata"), message: Text(commentViewModel.alertMessage))
//            }
//        }
        .onAppear(){
            likeViewModel.fetchDreamLike(dream: dream)
        }
        .navigationBarTitle("Rüya Detay")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddCommentScreen(dream: dream), isActive: $goToCommentScreen) {
                    Button {
                        self.goToCommentScreen = true
                    } label: {
                        Image(systemName: "ellipsis.bubble.fill").foregroundColor(.black)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                if dream.id != user?.uid{
                    Button{
                        if !likeViewModel.isLiked {
                            likeViewModel.likeDream(dream: dream)
                        } else{
                            likeViewModel.unLikeDream(dream: dream)
                        }
                    } label: {
                        Image(systemName: !likeViewModel.isLiked ? "heart" : "heart.fill").foregroundColor(!likeViewModel.isLiked ? .black : .red)
                    }
                }
            }
            ToolbarItem(placement: .bottomBar) {
                if dream.commentCount > 0{
                    Button {
                        if commentViewModel.dreamComments.count == 0{
                            commentViewModel.fetchCommentOfDream(dreamId: dream.id)
                        }
                        self.showComment = !self.showComment
                    } label: {
                        Text(!self.showComment || commentViewModel.dreamComments.count == 0 ? "Yorumları Görüntüle" : "Yorumları Gizle").foregroundColor(!self.showComment || commentViewModel.dreamComments.count == 0 ? .blue : .red)
                    }.padding(.vertical, 10)
                }
            }
        }
    }
}

struct DreamDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailScreen(dream: Dream(docID: "WEREWR", id: "", title: "Aslanların insan suretine girmesi ne demek oluyor?", description: "Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan suretine girmesi ne demek oluyor?Aslanların insan sure", likeCount: 0, commentCount: 0))
    }
}
