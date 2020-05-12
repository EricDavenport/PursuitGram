//
//  mainFeedCell.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

protocol FeedCellDelegate: AnyObject {
  func cellPostAssigned(_ feedCell: MainFeedCell, post: Post)
}

class MainFeedCell: UICollectionViewCell {
  
  
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var postCaptionLabel: UILabel!
  
  weak var delegate: FeedCellDelegate?
  
  private var currentPost: Post?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = 40.0
//    backgroundColor = .systemRed
//    postImageView.image = UIImage(systemName: "glasses")
    postCaptionLabel.backgroundColor = .white
  }
  
  public func configCell(for post: Post) {
    currentPost = post
    delegate?.cellPostAssigned(self, post: post)
    print("")
    print("post url = \(post.imageURL)")
    print("")
    postImageView.kf.setImage(with: URL(string: post.imageURL))
    postCaptionLabel.text = post.caption
    
  }
  
  private func updateUI(imageURL: String, postdate: Timestamp, caption: String) {
//    postImageView.kf.setImage(with: URL(string: imageURL))
//    postCaptionLabel.text = "ok"
  }
  
  
  
  
}
