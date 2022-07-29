//
//  DreamElementExplore.swift
//  myDream
//
//  Created by Cihat Tascı on 10.07.2022.
//

import SwiftUI

struct DreamElementExplore: View {
    let dream: Dream
    
    let size = UIScreen.main.bounds
    
    var body: some View {
        VStack(alignment: .leading){
            Text(dream.title).font(.subheadline).foregroundColor(.red).padding([.all], 5)
            Spacer()
            Text(dream.description).font(.body).foregroundColor(.blue).padding().lineLimit(5)
        }.frame(width: size.width * 0.35, height:size.height * 0.3).background(.gray)
    }
}

struct DreamElementExplore_Previews: PreviewProvider {
    static var previews: some View {
        DreamElementExplore(dream: Dream(id: "123", title: "title", description: "sdfsdsdfsdfsdfsdf"))
    }
}
