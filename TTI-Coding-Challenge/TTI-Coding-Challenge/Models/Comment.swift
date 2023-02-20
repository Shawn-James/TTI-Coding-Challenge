//
// Created by Shawn James
// Comment.swift

import Foundation

struct Comment: Decodable, Hashable {
    let id: String
    let body: String
    let author: String
    
    init(id: String, body: String?, author: String?) {
        self.id = id
        self.body = body ?? "Comment unavailable"
        self.author = author ?? "User unavailable"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
