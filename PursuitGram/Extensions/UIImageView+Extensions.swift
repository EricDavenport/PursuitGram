//
//  UIImageView+Extensions.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/9/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

extension UIImageView {
  
  func roundView() {
    self.layer.cornerRadius = 40.0
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.black.cgColor
    self.layer.masksToBounds = false
    self.clipsToBounds = true
  }
  
}
