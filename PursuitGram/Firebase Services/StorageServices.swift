//
//  StorageServices.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/9/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
  
  private let storRef = Storage.storage().reference()
  
  public func uploadPhoto(userEmail: String? = nil, docID: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
      return
    }
    
    var photoReference : StorageReference!
    
    if let userEmail  = userEmail {
      photoReference = storRef.child("UserProfilePhotos/\(userEmail).jpg")
      print("Saved with email")
    } else if let itemId = docID {
      photoReference = storRef.child("UserProfilePhotos/\(itemId).jpg")
      print("Saved with item ID")
    }
    
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    
    let _ = photoReference.putData(imageData, metadata: metaData) { (metaData, error) in
      if let error = error {
        completion(.failure(error))
      } else if let _ = metaData {
        photoReference.downloadURL { (url, error2) in
          if let error2 = error2 {
            completion(.failure(error2))
          } else if let url = url {
            completion(.success(url))
          }
        }
      }
    }
    
  }
  
}
