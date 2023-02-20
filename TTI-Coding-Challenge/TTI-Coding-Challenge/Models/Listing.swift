// 
// Created by Shawn James
// Listing.swift

import Foundation

struct Listing: Decodable {
    var posts: [Post]
    var comments: [Comment]
    let lastItemName: String?
    
    init(from decoder: Decoder) throws {
        var posts: [Post] = []
        var comments: [Comment] = []
        
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        let listingContainer = try container.nestedContainer(keyedBy: ListingCodingKeys.self, forKey: .data)
        let items = try listingContainer.decode([Item].self, forKey: .items)

        for item in items {
            let data = item.data
            switch item.kind {
            case .post:
                posts.append(Post(id: data.id, title: data.title, thumbnail: data.thumbnail, commentCount: data.commentCount))
            case .comment:
                comments.append(Comment(id: data.id, body: data.body, author: data.author))
            case .more:
                break
            }
        }

        self.posts = posts
        self.comments = comments
        self.lastItemName = try listingContainer.decodeIfPresent(String.self, forKey: .lastItemName)
    }
}

extension Listing {
    private struct Item: Decodable {
        let kind: ItemType
        let data: ItemData
    }
    
    private struct ItemData: Decodable {
        let id: String
        let title: String?
        let thumbnail: String?
        let commentCount: Int?
        let body: String?
        let author: String?
        
        enum CodingKeys: String, CodingKey {
            case id, title, thumbnail, body, author, commentCount = "num_comments"
        }
    }
    
    enum ItemType: String, Decodable {
        case post = "t3"
        case comment = "t1"
        case more = "more"
    }
    
    enum RootCodingKeys: String, CodingKey {
        case data
    }
    
    enum ListingCodingKeys: String, CodingKey {
        case items = "children"
        case lastItemName = "after"
    }
}
