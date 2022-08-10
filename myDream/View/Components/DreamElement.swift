//
//  DreamElement.swift
//  myDream
//
//  Created by Cihat Tascı on 30.06.2022.
//

import SwiftUI

struct DreamElement: View {
    let dream: Dream
    
    let size = UIScreen.main.bounds
    var body: some View {
        VStack{
            HStack{
                Text(dream.title).font(.headline).foregroundColor(.black).lineLimit(1)
                Spacer()
            }.padding([.bottom], 1)
            HStack{
                Text(dream.description).font(.body).foregroundColor(.black).lineLimit(3)
                Spacer()
            }.padding([.bottom], 1)
            HStack{
                Button {
                    print("s")
                } label: {
                    HStack {
                        Image(systemName: "heart").foregroundColor(.black).font(.system(size: 20))
                        Text("\(dream.likeCount)")
                    }
                }
                Button {
                    print("s")
                } label: {
                    HStack {
                        Image(systemName: "ellipsis.bubble.fill").foregroundColor(.black).font(.system(size: 20))
                        Text("\(dream.commentCount)")
                    }
                }
                Spacer()
            }.padding([.top], 1)
            
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).frame(width: .infinity)
    }
}

struct DreamElement_Previews: PreviewProvider {
    static var previews: some View {
        DreamElement(dream: Dream(docID: "dsfsdfsdfsdf", id: "34", title: "sdf", description: "sdfd", likeCount: 0, commentCount: 0))
    }
}
