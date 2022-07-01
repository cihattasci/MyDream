//
//  MyDreams.swift
//  myDream
//
//  Created by Cihat Tascı on 28.06.2022.
//

import SwiftUI
import Firebase

struct MyDreams: View {
    @ObservedObject var dreamViewModel = DreamManager()
    
    init(){
        dreamViewModel.fetchMyDreams()
    }
    
    func removeRows(at offsets: IndexSet){
        dreamViewModel.myDreams.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 0)
                    .background(Color(hex: 0x03fcbe))
                List{
                    ForEach(dreamViewModel.myDreams) { dream in
                        NavigationLink(destination: DreamDetailScreen()){
                            DreamElement(title: dream.title, description: dream.description)
                        }
                    }.onDelete(perform: removeRows)
                }
            }
            .navigationTitle("Rüyalarım")
            .navigationBarTitleDisplayMode(.inline )
        }
    }
}

struct MyDreams_Previews: PreviewProvider {
    static var previews: some View {
        MyDreams()
    }
}
