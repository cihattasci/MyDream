//
//  CommentElement.swift
//  myDream
//
//  Created by Cihat Tascı on 7.08.2022.
//

import SwiftUI

struct CommentElement: View {
    let comment: Comment
    let canEdit: Bool
    var body: some View {
        HStack{
            Text(comment.comment).foregroundColor(.black).lineLimit(4)
            if canEdit{
                Spacer()
                Circle().fill(Color(hex: 0x03fcbe)).frame(width: 9, height: 9)
            }
        }.padding([.horizontal], 5)
    }
}

//struct CommentElement_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentElement(comment: Comment(docID: "dsfg", id: "sdg", dreamId: "fgfd", comment: "sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfdsfdsfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf"), canEdit: true)
//    }
//}
