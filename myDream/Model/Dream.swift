//
//  Dream.swift
//  myDream
//
//  Created by Cihat Tascı on 27.06.2022.
//

import Foundation

struct Dream: Codable, Identifiable, Hashable{
    let docID: String
    let id: String
    let title: String
    let description: String
    let likeCount: Int
    let commentCount: Int
}

