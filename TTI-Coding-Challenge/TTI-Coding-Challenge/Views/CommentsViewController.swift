// 
// Created by Shawn James
// CommentsViewController.swift

import UIKit

// TODO: - Implement the nested comments

final class CommentsViewController: UITableViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    var listingService: ListingService?
    private var dataSource: UITableViewDiffableDataSource<Int, Comment>?

    var postId: String? {
        didSet {
            Task {
                self.applySnapshot(try await listingService?.fetchComments(for: postId ?? "") ?? [])
                loadingLabel.isHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    private func configureDataSource() {
         dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, comment in
             let cell = tableView.dequeueReusableCell(withIdentifier: "comment_cell", for: indexPath)
             cell.textLabel?.text = comment.author
             cell.detailTextLabel?.text = comment.body
             return cell
         }
     }
     
     private func applySnapshot(_ comments: [Comment]) {
         var snapshot = NSDiffableDataSourceSnapshot<Int, Comment>()
         snapshot.appendSections([0])
         snapshot.appendItems(comments)
         dataSource?.applySnapshotUsingReloadData(snapshot)
     }
}
