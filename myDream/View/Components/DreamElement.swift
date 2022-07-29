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
                Text(dream.title).font(.headline).foregroundColor(.black)
                Spacer()
            }
            Spacer()
            HStack{
                Text(dream.description).font(.body).foregroundColor(.black).lineLimit(2)
                Spacer()
            }
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).frame(width: .infinity, height: size.height * 0.07)
    }
}

struct DreamElement_Previews: PreviewProvider {
    static var previews: some View {
        DreamElement(dream: Dream(id: "34", title: "sdf", description: "sdfd"))
    }
}
