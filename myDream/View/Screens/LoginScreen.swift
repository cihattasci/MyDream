//
//  LoginScreen.swift
//  myDream
//
//  Created by Cihat Tascı on 2.06.2022.
//

import SwiftUI
import Firebase

struct LoginScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var loading: Bool = false
    @State var logged: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let size = UIScreen.main.bounds
    
    func login(){
        loading = true
        Auth.auth().signIn(withEmail: email, password: password){(result, error) in
            if error != nil{
                loading = false
                print(error?.localizedDescription ?? "")
            }else {
                loading = false
                logged = true
            }
        }

    }
    
    var body: some View {
        if(loading){
            ProgressView("Bekleniyor")
        } else{
            NavigationView{
                VStack{
                    Text("Giriş Yap").bold().font(.largeTitle).padding(EdgeInsets(top: size.height*0.1, leading: 0, bottom: size.height*0.1, trailing: 0))
                    
                    Input(value: $email, placeHolder: "E-posta", isSecure: false, width: size.width*0.9)
                    Input(value: $password, placeHolder: "Şifre", isSecure: true, width: size.width*0.9)

                    Spacer()
                    
                    NavigationLink(destination: Main(), isActive: $logged){
                        Button("Giriş Yap"){
                            login()
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: size.height*0.03, trailing: 0))
                    }
                    
                    Button("Kayıt Ol"){
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
