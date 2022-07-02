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
    @State var searchDream: String = ""
    
    init(){
        dreamsModelView.fetchAllDreams()
    }

    var body: some View {
        NavigationView{
            VStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 0)
                    .background(Color(hex: 0x03fcbe))
                if dreamsModelView.searchResult.count == 0 && !searchDream.isEmpty{
                    Text("Sonuç Bulunamadı").font(.footnote).foregroundColor(.black)
                } else{
                    List(dreamResult) { dream in
                        NavigationLink(destination: DreamDetailScreen()) {
                            DreamElement(title: dream.title, description: dream.description)
                        }
                    }.listStyle(.plain)
                }
            }
            .searchable(text: $searchDream, prompt: "Konu, metin veya başlık").onChange(of: searchDream, perform: { newValue in
                if newValue.isEmpty{
                    dreamsModelView.fetchAllDreams()
                } else{
                    dreamsModelView.searchDream(text: newValue)
                }
            }).foregroundColor(.black)
            .navigationTitle("Keşfet")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var dreamResult: [Dream]{
        if searchDream.isEmpty{
            return dreamsModelView.dreams
        } else{
            return dreamsModelView.searchResult
        }
    }
}

struct Explore_Previews: PreviewProvider {
    static var previews: some View {
        Explore()
    }
}
