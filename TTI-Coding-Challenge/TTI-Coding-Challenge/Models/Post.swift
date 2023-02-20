//
// Created by Shawn James
// Post.swift

import Foundation

struct Post: Decodable, Hashable {
    let id: String
    let title: String
    let thumbnail: String
    let commentCount: Int
    
    init(id: String, title: String?, thumbnail: String?, commentCount: Int?) {
        self.id = id
        self.title = title ?? "Untitled"
        self.thumbnail = thumbnail ?? ""
        self.commentCount = commentCount ?? 0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
