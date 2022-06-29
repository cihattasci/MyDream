//
//  Explore.swift
//  myDream
//
//  Created by Cihat Tascı on 21.06.2022.
//

import SwiftUI
import Firebase

struct Explore: View {
    @ObservedObject var dreamsModelView = DreamManager()
    
    init(){
        dreamsModelView.fetchAllDreams()
    }

    var body: some View {
        NavigationView{
            VStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 0)
                    .background(Color(hex: 0x03fcbe))
                List(dreamsModelView.dreams) { dream in
//                    DreamElement(title: dream.title, description: dream.description)
                    Text(dream.title).foregroundColor(.red)
                }
                
//                ForEach(dreamsModelView.dreams) { dream in
//                    DreamElement(title: dream.title, description: dream.description)
//                }
                
//                Spacer()
            }
        }
        .navigationTitle("Keşfet")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Explore_Previews: PreviewProvider {
    static var previews: some View {
        Explore()
    }
}
