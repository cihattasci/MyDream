//
//  MyDreams.swift
//  myDream
//
//  Created by Cihat Tascı o  n 28.06.2022.
//

import SwiftUI
import Firebase

struct EmptyMyDream: View{
    @Binding var goAddDream: Bool
    
    var body: some View{
        VStack {
            Image(systemName: "moon.stars.fill").font(.system(size: UIScreen.main.bounds.height * 0.2)).foregroundColor(.black)
            HStack {
                Text("Buralar mışıl mışıl..").font(.title3)
                Button {
                    goAddDream = true
                } label: {
                    Text("Rüyanı Paylaş").font(.title3)
                }.foregroundColor(.blue)
            }.padding([.top], 10)
        }
    }
}

struct MyDreams: View {
    @ObservedObject var dreamViewModel = DreamManager()
    @State var addScreen: Bool = false
    @State var goToEdit: Bool = false
    
    init(){
        dreamViewModel.fetchMyDreams()
    }
    
    func removeDream(dream: Dream){
        dreamViewModel.deleteDream(dream: dream)
    }
    
    var body: some View {
        if dreamViewModel.loading{
            ProgressView("İşlem Gerçekleştiriliyor..")
        } else{
            NavigationView{
                VStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 0)
                        .background(Color(hex: 0x03fcbe))
                    if dreamViewModel.myDreams.count != 0{
                        List{
                            ForEach(dreamViewModel.myDreams, id: \.self) { dream in
                                DreamElement(dream: Dream(docID: dream.docID, id: dream.id, title: dream.title, description: dream.description, likeCount: dream.likeCount, commentCount: dream.commentCount))
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        removeDream(dream: dream)
                                    } label: {
                                        Label("Sil", systemImage: "trash").foregroundColor(.white)
                                    }
                                }
                            }
                        }.refreshable {
                            dreamViewModel.fetchMyDreams()
                        }
                    } else{
                        EmptyMyDream(goAddDream: $addScreen)
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        NavigationLink(destination: AddDreamScreen().accentColor(.black), isActive: $addScreen) {
                            Button {
                                self.addScreen = true
                            } label: {
                                Image(systemName: "plus").foregroundColor(.black)
                            }
                            
                        }
                    })
                }
                .navigationTitle("Rüyalarım")
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }
    }
}

struct MyDreams_Previews: PreviewProvider {
    static var previews: some View {
        MyDreams()
    }
}
