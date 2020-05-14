//
//  Date+Extension.swift
//  PursuitGram
//
//  Created by Eric Davenport on 5/14/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation

extension Date {
  public func dateString(_ format: String = "EEEE, MMM d. h:mm:ss a") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    // self
    return dateFormatter.string(from: self)
    
  }
}
