//
//  Like.swift
//  myDream
//
//  Created by Cihat Tascı on 9.08.2022.
//

import Foundation

struct Like: Codable, Identifiable, Hashable{
    let docID: String
    let id: String
    let dreamId: String
    let dream: Dream
}
