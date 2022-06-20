//
//  SignUpScreen.swift
//  myDream
//
//  Created by Cihat Tascı on 2.06.2022.
//

import SwiftUI
import Firebase

struct SignUpScreen: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordTwo: String = ""
    @State var loading: Bool = false
    @State var login: Bool = false
    @State var signed: Bool = false
    
    let size = UIScreen.main.bounds
    
    func signUp(){
        loading = true
        Auth.auth().createUser(withEmail: email, password: password){(result, error) in
            if error != nil{
                loading = false
                print(error?.localizedDescription ?? "")
            }else {
                loading = false
                signed = true
            }
        }
    }
    
    var body: some View {
        if(loading){
            ProgressView("Bekleniyor")
        } else{
            NavigationView{
                VStack{
                    Text("Kayıt Ol").bold().font(.largeTitle).padding(EdgeInsets(top: size.height*0.1, leading: 0, bottom: size.height*0.1, trailing: 0))
                    
                    Input(value: $email, placeHolder: "E-posta", isSecure: false, width: size.width*0.9)
                    Input(value: $password, placeHolder: "Şifre", isSecure: true, width: size.width*0.9)
                    Input(value: $passwordTwo, placeHolder: "Şifre Tekrar", isSecure: true, width: size.width*0.9)

                    Spacer()
                    
                    NavigationLink(destination: Main(), isActive: $signed){
                        Button("Kayıt Ol"){
                            signUp()
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: size.height*0.03, trailing: 0))
                    }
                    
                    NavigationLink(destination: LoginScreen().navigationBarHidden(true), isActive: $login){
                        Button("Giriş Yap"){
                            login = true
                        }
                    }
                    
                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
