//
//  DreamElement.swift
//  myDream
//
//  Created by Cihat Tascı on 30.06.2022.
//

import SwiftUI

struct DreamElement: View {
    let title: String
    let description: String
    
    let size = UIScreen.main.bounds
    var body: some View {
        VStack{
            HStack{
                Text(title).font(.title)
                Spacer()
            }
            Spacer()
            HStack{
                Text(description).font(.body).lineLimit(2)
                Spacer()
            }
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).frame(width: size.width * 0.9, height: size.height * 0.11).overlay(RoundedRectangle(cornerRadius: 10).stroke(.brown, lineWidth: 2))
    }
}

//struct DreamElement_Previews: PreviewProvider {
//    static var previews: some View {
//        DreamElement()
//    }
//}
