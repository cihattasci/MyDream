//
//  Comment.swift
//  myDream
//
//  Created by Cihat Tascı on 31.07.2022.
//

import Foundation

struct Comment: Codable, Identifiable, Hashable{
    let docID: String
    let id: String
    let dreamId: String
    var comment: String
}
