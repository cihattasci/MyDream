//
//  Input.swift
//  myDream
//
//  Created by Cihat Tascı on 2.06.2022.
//

import SwiftUI

struct Input: View {
    @Binding var value: String
    
    let placeHolder: String
    let isSecure: Bool
    let width: CGFloat
    
    var body: some View {
        if(!isSecure){
            TextField(placeHolder, text: $value).padding(15).frame(width: width).overlay(RoundedRectangle(cornerRadius: 15).stroke(.black, lineWidth: 2))
        } else{
            SecureField(placeHolder, text: $value).padding(15).frame(width: width).overlay(RoundedRectangle(cornerRadius: 15).stroke(.black, lineWidth: 2))
        }
    }
}

