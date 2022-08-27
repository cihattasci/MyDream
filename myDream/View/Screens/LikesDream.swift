//
//  LikesDream.swift
//  myDream
//
//  Created by Cihat Tascı on 12.08.2022.
//

import SwiftUI

struct EmptyLikeScreen: View{
    var body: some View{
        VStack{
            Image(systemName: "heart.slash.fill").font(.system(size: UIScreen.main.bounds.height * 0.18)).foregroundColor(.red)
            HStack {
                Text("Hmm... Beğenilmemiş.").font(.title3)
                Button {
                    print("sdffsd")
                } label: {
                    Text("Rüyalara Bir Gözat").font(.title3)
                }.foregroundColor(.blue)
            }.padding([.top], 10)
        }
    }
}

struct LikesDream: View {
    @ObservedObject var likeViewModel = LikeManager()
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 0)
                .edgesIgnoringSafeArea(.top)
                .background(Color(hex: 0x03fcbe))
            if likeViewModel.myLikes.count != 0 {
                List{
                    ForEach(likeViewModel.myLikes, id: \.self){like in
                        NavigationLink(destination: DreamDetailScreen(dream: like.dream)) {
                            DreamElement(dream: Dream(docID: like.dream.docID, id: like.dream.id, title: like.dream.title, description: like.dream.description, likeCount: like.dream.likeCount, commentCount: like.dream.commentCount))
                        }
                    }
                }.refreshable {
                    likeViewModel.fetchMyLikes()
                }
            } else {
//                EmptyLikeScreen()
                Image(systemName: "heart.slash.fill").font(.system(size: UIScreen.main.bounds.height * 0.18)).foregroundColor(.red)
                HStack {
                    Text("Hmm... Beğenilmemiş.").font(.title3)
                    Button {
                        print("sdffsd")
                    } label: {
                        Text("Rüyalara Bir Gözat").font(.title3)
                    }.foregroundColor(.blue)
                }.padding([.top], 10)
            }
        }
        .onAppear(){
            likeViewModel.fetchMyLikes()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Beğeniler")
    }
}

struct LikesDream_Previews: PreviewProvider {
    static var previews: some View {
        LikesDream()
    }
}
