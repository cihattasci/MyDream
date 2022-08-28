//
//  AuthManager.swift
//  myDream
//
//  Created by Cihat Tascı on 26.06.2022.
//

import Foundation
import Firebase

enum AlertType{
    case success, error
}

class AuthManager: ObservableObject{
    @Published var session: Bool = false
    @Published var loading: Bool = true
    @Published var alert: Bool = false
    @Published var alertType: AlertType = .success
    @Published var alertText: String = ""
    
    init(){
        Auth.auth().addStateDidChangeListener { auth, user in
            self.loading = false
            self.session = user != nil
        }
    }
    
    func updatePassword(newPassword: String, newPasswordSecond: String){
        if newPassword != newPasswordSecond{
            self.alert = true
            self.alertType = .error
            self.alertText = "Şifreler Eşleşmiyor"
        } else{
            self.loading = true
            Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { error in
                if let error = error {
                    self.alert = true
                    self.alertType = .error
                    self.alertText = error.localizedDescription
                    self.loading = false
                    return
                }
                
                self.alert = true
                self.alertType = .success
                self.alertText = "Şifre Güncellendi"
                self.loading = false
            })
        }
    }
    
    func updateEmail(newMail: String){
        self.loading = true
        Auth.auth().currentUser?.updateEmail(to: newMail, completion: { error in
            self.alert = true
            if let error = error {
                self.alertType = .error
                self.alertText = error.localizedDescription
                self.loading = false
                return
            }
            self.alertType = .success
            self.alertText = "Şifre Güncellendi"
            self.loading = false
        })
    }
}
