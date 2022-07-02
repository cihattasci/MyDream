//
//  Settings.swift
//  myDream
//
//  Created by Cihat Tascı on 20.06.2022.
//

import SwiftUI
import Firebase

struct Settings: View {
    
    @State var loading: Bool = false
        
    func signOut(){
        do{
            loading = true
            try Auth.auth().signOut()
        } catch{
            loading = false
        }
    }
    
    var body: some View {
        NavigationView{
            if loading{
                ProgressView()
            } else{
                VStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 0)
                        .background(Color(hex: 0x03fcbe))
                    Button{
                        self.signOut()
                    } label: {
                        Text("Çıkış")
                }
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
