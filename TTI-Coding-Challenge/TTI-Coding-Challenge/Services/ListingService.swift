// 
// Created by Shawn James
// ListingService.swift

import UIKit
import Combine

// TODO: - Error handling

final class ListingService {
    let sortMode: SortMode
    private let baseUrl = URL(string: "http://www.reddit.com/r/all")
    private var pageLimit = 15
    private var fetchedItemCount = 0
    private var lastItemName: String?
    
    init(sortMode: SortMode) {
        self.sortMode = sortMode
    }
    
    /// Combine
    func fetchMorePosts() -> AnyPublisher<[Post], Never> {
        var endpoint = baseUrl?.appending(path: sortMode.path)
        endpoint?.append(queryItems: [
            URLQueryItem(name: "after", value: lastItemName),
            URLQueryItem(name: "limit", value: String(pageLimit)),
            URLQueryItem(name: "count", value: String(fetchedItemCount))
        ])
        guard let endpoint else {
            fatalError("Developer error: Constructed a bad URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: endpoint)
            .map(\.data)
            .decode(type: Listing.self, decoder: JSONDecoder())
            .map { listing -> [Post] in
                self.fetchedItemCount += listing.posts.count
                self.lastItemName = listing.lastItemName
                return listing.posts
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }

    /// Async await
    func fetchComments(for postId: String) async throws -> [Comment] {
        guard let endpoint = baseUrl?.appending(component: "comments").appending(path: postId).appending(path: ".json") else {
            fatalError("Developer error: Constructed a bad URL")
        }
        let (data, _) = try await URLSession.shared.data(from: endpoint)
        let listing = try JSONDecoder().decode([Listing].self, from: data)
        return listing.flatMap(\.comments)
    }
}

