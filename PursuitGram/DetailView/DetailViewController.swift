//
//  DetailViewController.swift
//  PursuitGram
//
//  Created by Eric Davenport on 5/14/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

  @IBOutlet weak var dislayNameLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var captionLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  private var post: Post
  
  init?(coder: NSCoder, post: Post) {
    self.post = post
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    updateUI()
    }
    
  private func updateUI() {
    let date = post.date.dateValue()
    imageView.kf.setImage(with: URL(string: post.imageURL))
    dislayNameLabel.text = "\(post.displayName)'s post"
    dateLabel.text = "\(date.dateString())"
    captionLabel.text = post.caption
  }


}
