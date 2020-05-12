//
//  DatabaseService.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/9/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
  
  static let itemCollection = "items"
  static let usersCollection = "users"
  
  private let db = Firestore.firestore()
  
  public func createPost(caption: String, displayName: String, completion: @escaping (Result<String, Error>) -> ()) {
    print("create post func inside")
    guard let user = Auth.auth().currentUser else { return }
    
    let documentRef = db.collection(DatabaseService.itemCollection).document()
    
    db.collection(DatabaseService.itemCollection).document(documentRef.documentID).setData(["caption": caption, "displayName": displayName, "itemID": documentRef.documentID, "listedDate": Timestamp(date: Date()), "userID": user.uid]) { (error) in
      if let error = error {
        print("fail - db service")
        completion(.failure(error))
      } else {
        print("success - db service")
        completion(.success(documentRef.documentID))
      }
    }
  }
  
  public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let email = authDataResult.user.email else { return }
    db.collection(DatabaseService.usersCollection).document(authDataResult.user.uid).setData(
    ["email": email,
     "createdDate": Timestamp(date: Date()),
     "userId": authDataResult.user.uid]) { (error) in
             if let error = error {
               completion(.failure(error))
             } else {
               completion(.success(true))
             }
         }
    }
  
  public func updateDatabaseUser(displayName: String, photoURL: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let user = Auth.auth().currentUser else { return }
    
    db.collection(DatabaseService.usersCollection).document(user.uid).updateData(
      ["displayName": displayName,
       "photoURL": photoURL]) { (error) in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(true))
        }
    }
  }
  
  
  }
  
  
  

