// 
// Created by Shawn James
// PostsViewModel.swift

import Foundation
import Combine
import OrderedCollections

final class PostsViewModel {
    @Published private(set) var posts = OrderedSet<Post>()
    @Published private(set) var sortButtonTitle: String?
    private(set) var listingService: ListingService
    var subscriptions = Set<AnyCancellable>()
    var loadMorePosts = PassthroughSubject<Void, Never>()
    
    init(sortMode: SortMode) {
        listingService = ListingService(sortMode: sortMode)
        sortButtonTitle = sortMode.displayName
        setupPostPipeline()
        loadMorePosts.send()
    }
    
    func toggleSortMode() {
        if let currentIndex = SortMode.allCases.firstIndex(of: listingService.sortMode) {
            posts.removeAll()
            let nextMode = SortMode.allCases[(currentIndex + 1) % SortMode.allCases.count]
            listingService = ListingService(sortMode: nextMode)
            sortButtonTitle = listingService.sortMode.displayName
            loadMorePosts.send()
        }
    }
    
    private func setupPostPipeline() {
        loadMorePosts
            .map(listingService.fetchMorePosts)
            .receive(on: DispatchQueue.main)
            .switchToLatest()
            .sink { [weak self] newPosts in
                self?.posts.append(contentsOf: newPosts)
            }
            .store(in: &subscriptions)
    }
}
