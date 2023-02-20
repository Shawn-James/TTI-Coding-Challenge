// 
// Created by Shawn James
// PostTableViewCell.swift

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
        
    func configure(with post: Post) {
        thumbnailView.loadImage(with: post.thumbnail)
        titleLabel.text = post.title
        subtitleLabel.text = "💬 \(post.commentCount)"
    }
}
