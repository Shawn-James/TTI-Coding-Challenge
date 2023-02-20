// 
// Created by Shawn James
// PostsViewController.swift

import UIKit

final class PostsViewController: UITableViewController {
    @IBOutlet weak var sortButton: UIBarButtonItem!
    private lazy var viewModel = PostsViewModel(sortMode: .best)
    private var dataSource: UITableViewDiffableDataSource<Int, Post>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.toggleSortMode()
    }
    
    private func configureDataSource() {
         dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, post in
             let cell = tableView.dequeueReusableCell(withIdentifier: "post_cell", for: indexPath) as! PostTableViewCell
             cell.configure(with: post)
             return cell
         }
     }
     
     private func bindViewModel() {
         viewModel.$posts
             .receive(on: DispatchQueue.main)
             .sink { [weak self] posts in
                 self?.applySnapshot(posts.elements)
             }
             .store(in: &viewModel.subscriptions)
         
         viewModel.$sortButtonTitle
             .receive(on: DispatchQueue.main)
             .assign(to: \.title, on: sortButton)
             .store(in: &viewModel.subscriptions)
     }
     
     private func applySnapshot(_ posts: [Post]) {
         var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
         snapshot.appendSections([0])
         snapshot.appendItems(posts)
         dataSource?.apply(snapshot)
     }
}

// Mark: - UITableViewDelegate

extension PostsViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            viewModel.loadMorePosts.send()
        }
    }
}

// Mark: - UIStoryboardSegue

extension PostsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let commentsViewController = segue.destination as? CommentsViewController,
              let selectedRow = tableView.indexPathForSelectedRow?.row
        else { return }

        commentsViewController.listingService = viewModel.listingService
        commentsViewController.postId = viewModel.posts[selectedRow].id
    }
}
