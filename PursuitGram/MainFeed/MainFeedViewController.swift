//
//  MainFeedViewController.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MainFeedViewController: UIViewController {

  @IBOutlet weak var mainFeedCollection: UICollectionView!
  
  private var posts = [Post]() {
    didSet {
      DispatchQueue.main.async {
        self.mainFeedCollection.reloadData()
      }
    }
  }
  
  private var listener: ListenerRegistration?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    listenerSetup()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(true)
    listener?.remove()
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    collectionViewSetup()
        // Do any additional setup after loading the view.
    }
  
  private func collectionViewSetup() {
    mainFeedCollection.delegate = self
    mainFeedCollection.dataSource = self
  }
  
  private func listenerSetup() {
    listener = Firestore.firestore().collection(DatabaseService.itemCollection).addSnapshotListener({ [weak self] (snapshot, error) in
      if let error = error {
        DispatchQueue.main.async {
          self?.showAlert(title: "Firestore Error", message: "\(error.localizedDescription)")
        }
      } else if let snapshot = snapshot {
        print("there are \(snapshot.documents.count) post made")
        let post = snapshot.documents.map { Post($0.data())}
        let sorted = post.sorted { $0.date.seconds > $1.date.seconds}
        self?.posts = sorted
      }
    })
  }
    


}

extension MainFeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? MainFeedCell else {
      fatalError("unable to downcast MainFeedCell")
    }
    let post = posts[indexPath.row]
    cell.configCell(for: post)
    cell.backgroundColor = .magenta
    cell.delegate = self
    return cell
  }
  
  
}

extension MainFeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemSize = CGSize(width: 200, height: 200)
    return itemSize
  }
}

extension MainFeedViewController: FeedCellDelegate {
  func cellPostAssigned(_ feedCell: MainFeedCell, post: Post) {
//    feedCell.configCell(for: post)
  }
  
  
}


