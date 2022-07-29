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
    @State var goToEdit: Bool = false
    
    init(){
        dreamViewModel.fetchMyDreams()
    }
    
    func removeDream(dream: Dream){
        dreamViewModel.deleteDream(dream: dream)
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
                        ForEach(dreamViewModel.myDreams, id: \.self) { dream in
                            NavigationLink(destination: EditDreamScreen()){
                                DreamElement(dream: Dream(id: dream.id, title: dream.title, description: dream.description))
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    removeDream(dream: dream)
                                } label: {
                                    Label("Sil", systemImage: "trash").foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        NavigationLink(destination: AddDreamScreen().accentColor(.black), isActive: $addScreen) {
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
