//
//  Main.swift
//  myDream
//
//  Created by Cihat Tascı on 21.06.2022.
//

import SwiftUI

struct Main: View {
    var body: some View {
        TabView{
            Explore().navigationBarBackButtonHidden(true)
                .tabItem{
                    Label("Keşfet", systemImage: "Home")
                }
            Search()
                .tabItem{
                    Label("Ara", systemImage: "Home")
                }
            Settings()
                .tabItem{
                    Label("Ayarlar", systemImage: "Gear")
                }
        }
    }
}

