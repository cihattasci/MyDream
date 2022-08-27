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
    @State var notification: Bool = false
    
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
                        .edgesIgnoringSafeArea(.top)
                        .background(Color(hex: 0x03fcbe))
                    Form {
                        Section{
                            NavigationLink {
                                LikesDream()
                            } label: {
                                Text("Beğeniler")
                            }
                            NavigationLink {
                                CommentedDream()
                            } label: {
                                Text("Tabir Ettiklerim")
                            }
                            //Text("Kaydedilenler")
                        } header: {
                            Text("Etkileşimler")
                        }
                        Section{
                            Toggle(isOn: $notification) {
                                Text("Bildirimler")
                            }
                            NavigationLink {
                                ChangePassword()
                            } label: {
                                Text("Şifre Değiştir")
                            }
                            NavigationLink {
                                ChangeEmail()
                            } label: {
                                Text("E-Posta Değiştir")
                            }
                            //Text("Dil & Bölge")
                        } header: {
                            Text("Hesap Ayarları")
                        }
                        Section {
                            Button{
                                self.signOut()
                            } label: {
                                Text("Çıkış Yap").foregroundColor(.black)
                            }
                        } header: {
                            Text("Oturum")
                        }
                    }
                }
                .navigationTitle("Ayarlar")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(false)
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
