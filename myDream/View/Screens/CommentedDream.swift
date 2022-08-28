//
//  CommentedDream.swift
//  myDream
//
//  Created by Cihat Tascı on 12.08.2022.
//

import SwiftUI

struct CommentedDream: View {
    @ObservedObject var commentViewModel = Commentmanager()
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 0)
                .edgesIgnoringSafeArea(.top)
                .background(Color(hex: 0x03fcbe))
            List{
                ForEach(commentViewModel.myComments, id: \.self) {comment in
                    NavigationLink(destination: DreamDetailScreen(dream: comment.dream)){
                        CommentElement(comment: comment, canEdit: true)
                    }
                }
            }
            .refreshable {
                commentViewModel.getMyComments()
            }
        }
        .onAppear(){
            commentViewModel.getMyComments()
        }
        .navigationTitle("Yorumlarım")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentedDream_Previews: PreviewProvider {
    static var previews: some View {
        CommentedDream()
    }
}
