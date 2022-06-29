//
//  AddDream.swift
//  myDream
//
//  Created by Cihat Tascı on 22.06.2022.
//

import SwiftUI
import Firebase

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct AddDream: View {
    @State var title: String = ""
    @State var description: String = ""
    @State var loading: Bool = false
    @State var alert: Bool = false
    @State var successAlert: Bool = false
    
    let uid = Auth.auth().currentUser?.uid
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    func addDream(){
        if(!title.isEmpty && !description.isEmpty){
            loading = true
            Firestore.firestore().collection("dreams").addDocument(data: ["id": uid, "title": title, "description": description]) { error in
                if error != nil{
                    loading = false
                    successAlert = false
                    alert = true
                } else{
                    title = ""
                    description = ""
                    loading = false
                    successAlert = true
                    alert = true
                }
            }
        } else{
            successAlert = false
            alert = true
        }
    }
    
    var body: some View {
        if(loading){
            ProgressView("Rüya Yükleniyor").foregroundColor(.blue)
        } else{
            NavigationView{
                VStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 0)
                        .background(Color(hex: 0x03fcbe))
                    TextField("Rüya Başlığı", text: $title)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5))
                        .padding([.top], 20)
                    
                    TextField("Rüya İçeriği", text: $description)
                        .frame(height: height*0.3)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.sentences)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5))
                        .padding([.bottom, .top], 20)
                    
                    Button{
                        addDream()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15).frame(height: height*0.05).foregroundColor(.white).overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5).foregroundColor(.black))
                            Text("Rüyanı Ekle").foregroundColor(.black)
                        }
                    }
                    Spacer()
                        .alert(isPresented: $alert) {
                            if !successAlert{
                                return Alert(title: Text("Hata"),message: Text("Lütfen alanları eksiksiz ve doğru şekilde doldurunuz.."))
                            } else{
                                return Alert(title: Text("Tebrikler"), message: Text("Rüyanız Başarıyla Yüklendi"))
                            }
                        }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .navigationTitle("Rüyanı Paylaş")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct AddDream_Previews: PreviewProvider {
    static var previews: some View {
        AddDream()
    }
}
