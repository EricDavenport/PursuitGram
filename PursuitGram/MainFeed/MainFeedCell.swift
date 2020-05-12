//
//  mainFeedCell.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import Kingfisher

class MainFeedCell: UICollectionViewCell {
  
  
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var postCaptionLabel: UILabel!
  
  private var currentPost: Post!
  
  public func configCell(for post: Post) {
    currentPost = post
    postCaptionLabel.text = "Test"
    print("current post \(currentPost.caption)")
//    cellImageView.kf.setImage(with: URL(string: currentPost.postURL))
//    captionLabel.text = currentPost.caption
    
  }
  
  
}
