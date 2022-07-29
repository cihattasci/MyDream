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
                if dreamsModelView.searchResultTitle.count == 0 && dreamsModelView.searchResultDescription.count == 0 && !searchDream.isEmpty{
                    Text("Sonuç Bulunamadı").font(.footnote).foregroundColor(.black)
                } else if ((dreamsModelView.searchResultTitle.count != 0 || dreamsModelView.searchResultDescription.count != 0) && !searchDream.isEmpty){
                    List{
                        if dreamsModelView.searchResultTitle.count != 0 {
                            Section(header: Text("Başlık").font(.callout)) {
                                ForEach(dreamsModelView.searchResultTitle, id: \.self){dream in
                                    NavigationLink(destination: DreamDetailScreen()) {
                                        Text(dream.title)
                                    }
                                }
                            }}
                        
                        if dreamsModelView.searchResultDescription.count != 0 {
                            Section(header: Text("Konu").font(.callout)) {
                                ForEach(dreamsModelView.searchResultDescription, id: \.self){dream in
                                    NavigationLink(destination: DreamDetailScreen()) {
                                        Text(dream.description)
                                    }
                                }
                            }}
                    }.listStyle(.insetGrouped)
                } else{
                    List{
                        ForEach(dreamsModelView.dreams, id: \.self){dream in
                            NavigationLink(destination: DreamDetailScreen()) {
                                DreamElement(dream: Dream(id: dream.id, title: dream.title, description: dream.description))
                            }
                        }
                    }.listStyle(.insetGrouped)
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
}

struct Explore_Previews: PreviewProvider {
    static var previews: some View {
        Explore()
    }
}
