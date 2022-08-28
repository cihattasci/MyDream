//
//  Settings.swift
//  myDream
//
//  Created by Cihat Tascı on 20.06.2022.
//

import SwiftUI
import Firebase

struct Settings: View {
    @ObservedObject var authViewModel = AuthManager()
    @State private var loading: Bool = false
    @State private var notification: Bool = false
    @State private var openSheet: Bool = false
    @State private var newEmail: String = ""
    
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
                            Button {
                                self.openSheet.toggle()
                            } label: {
                                Text("E-Posta Değiştir").foregroundColor(.black)
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
                .alert(isPresented: $authViewModel.alert){
                    if authViewModel.alertType == .success{
                        return Alert(title: Text("İşlem Başarılı"), message: Text(authViewModel.alertText), dismissButton: .default(Text("Kapat"), action: {
                            self.openSheet = false
                        }))
                    } else{
                        return Alert(title: Text("Hata"), message: Text(authViewModel.alertText), dismissButton: .default(Text("Kapat")))
                    }
                }
                .sheet(isPresented: $openSheet, content: {
                    VStack{
                        Input(value: $newEmail, placeHolder: "Yeni posta", isSecure: false, width: UIScreen.main.bounds.width * 0.9).padding([.top], 30)
                        Spacer()
                        Button {
                            authViewModel.updateEmail(newMail: newEmail)
                        } label: {
                            Text("Güncelle").foregroundColor(.blue)
                        }.disabled(self.newEmail.isEmpty)
                    }
                })
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
