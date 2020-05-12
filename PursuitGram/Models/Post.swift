//
//  Post.swift
//  PursuitGram
//
//  Created by Eric Davenport on 5/7/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation
import Firebase

struct Post {
  let userID: String
  let itemID: String
  let caption: String
  let displayName: String
  let date: Timestamp
  let imageURL: String
}

extension Post {
  init(_ dictionary: [String: Any]) {
    self.userID = dictionary["userID"] as? String ?? "No user id"
    self.itemID = dictionary["itemID"] as? String ?? "No item id"
    self.caption = dictionary["caption"] as? String ?? "No caption"
    self.displayName = dictionary["displayName"] as? String ?? "No display name"
    self.date = dictionary["postDate"] as? Timestamp ?? Timestamp(date: Date())
    self.imageURL = dictionary["imageURL"] as? String ?? "no image url"

  }
}
