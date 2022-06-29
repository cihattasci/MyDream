//
//  Main.swift
//  myDream
//
//  Created by Cihat Tascı on 21.06.2022.
//

import SwiftUI
import Firebase

struct Main: View {
    var body: some View {
        TabView{
            Explore().navigationBarBackButtonHidden(true)
                .tabItem{
                    Label("Keşfet", systemImage: "eye.fill")
                }
            AddDream().navigationBarBackButtonHidden(true)
                .tabItem{
                    Label("Paylaş", systemImage: "plus.message.fill")
                }
            MyDreams().navigationBarBackButtonHidden(true)
                .tabItem{
                    Label("Rüyalarım", systemImage: "paperclip.circle.fill")
                }
            Settings().navigationBarBackButtonHidden(true)
                .tabItem{
                    Label("Ayarlar", systemImage: "gearshape.fill")
                }
        }
    }
}

