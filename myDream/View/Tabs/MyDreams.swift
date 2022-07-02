//
//  MyDreams.swift
//  myDream
//
//  Created by Cihat Tascı o  n 28.06.2022.
//

import SwiftUI
import Firebase

struct MyDreams: View {
    @ObservedObject var dreamViewModel = DreamManager()
    @State var addScreen: Bool = false
    
    init(){
        dreamViewModel.fetchMyDreams()
    }
    
    func removeRows(at offsets: IndexSet){
        dreamViewModel.deleteDream(index: offsets)
    }
    
    var body: some View {
        if dreamViewModel.loading{
            ProgressView("İşlem Gerçekleştiriliyor..")
        } else{
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
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        NavigationLink(destination: AddDream().accentColor(.black), isActive: $addScreen) {
                            Button {
                                self.addScreen = true
                            } label: {
                                Image(systemName: "plus").foregroundColor(.black)
                            }

                        }
                    })
                }
                .navigationTitle("Rüyalarım")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct MyDreams_Previews: PreviewProvider {
    static var previews: some View {
        MyDreams()
    }
}
