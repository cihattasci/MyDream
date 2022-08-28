//
//  ChangePassword.swift
//  myDream
//
//  Created by Cihat Tascı on 12.08.2022.
//

import SwiftUI

struct ChangePassword: View {
    @ObservedObject var authViewModel = AuthManager()
    
    @State private var newPassword: String = ""
    @State private var newPasswordSecond: String = ""
    @State private var isSecured: Bool = true
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 0)
                .edgesIgnoringSafeArea(.top)
                .background(Color(hex: 0x03fcbe))
            if authViewModel.loading{
                ProgressView("İşlem Gerçekleştiriliyor..")
            } else{
                VStack{
                    HStack{
                        Group {
                            if isSecured {
                                SecureField("Yeni Şifre", text: $newPassword).disableAutocorrection(true).textInputAutocapitalization(.never)
                            } else {
                                TextField("Yeni Şifre", text: $newPassword)
                            }
                        }
                        
                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.blue)
                        }
                    }.padding([.horizontal, .vertical], 20)
                    HStack{
                        Group {
                            if isSecured {
                                SecureField("Yeni Şifre Tekrar", text: $newPasswordSecond)
                            } else {
                                TextField("Yeni Şifre Tekrar", text: $newPasswordSecond)
                            }
                        }
                    }.padding([.horizontal, .bottom], 20)
                    Button {
                        authViewModel.updatePassword(newPassword: newPassword, newPasswordSecond: newPasswordSecond)
                    } label: {
                        Text("Güncelle").foregroundColor(.blue)
                    }
                    .padding([.top], 20)
                    .disabled(self.newPassword.isEmpty || self.newPasswordSecond.isEmpty)
                    Spacer()
                }.padding([.top], 30)
            }
        }
        .alert(isPresented: $authViewModel.alert){
            if authViewModel.alertType == .success{
                return Alert(title: Text("İşlem Başarılı"), message: Text(authViewModel.alertText), dismissButton: .default(Text("Kapat"), action: {
                    self.newPassword = ""
                    self.newPasswordSecond = ""
                }))
            } else{
                return Alert(title: Text("Hata"), message: Text(authViewModel.alertText), dismissButton: .default(Text("Kapat")))
            }
        }
        .navigationTitle("Şifre Değiştir")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword()
    }
}
