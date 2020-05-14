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
    cell.didSelectDelegate = self
    
    return cell
  }
  
  
}

extension MainFeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemSize = CGSize(width: 200, height: 200)
    return itemSize
  }
  
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let post = posts[indexPath.row]
//    print(post.date)
//    
//  }
  
  /*
      let podcast = podcasts[indexPath.row]
       print(podcast.collectionName)
       
       // segue to the PodcastDetailController
       // access the PodcastDetailController from storyboard
       
       // make sure that the stodyboard id is set for the PodcastDetailController
       let podcastDetailStoryboard = UIStoryboard(name: "PodcastDetail", bundle: nil)
       guard let podcastDetailController = podcastDetailStoryboard.instantiateViewController(identifier: "PodcastDetailController") as? PodcastDetailController else {
         fatalError("failed to downcast to PodcastDetailController")
       }
       podcastDetailController.podcasts = podcast
       // in the coming weeks or next week - we will pass datat using initializers / dependency injection e.g PodcatDetailController(podcast: podcast)
       navigationController?.pushViewController(podcastDetailController, animated: true)
       
       //show(pocastDetailController, sender: nil
     }
   }



   */
}

extension MainFeedViewController: FeedCellDelegate {
  func cellPostAssigned(_ feedCell: MainFeedCell, post: Post) {
//    feedCell.configCell(for: post)
  }
  
  func didSelectPost(_ feedCell: MainFeedCell, post: Post) {
    print("delegate active")
    guard let indexPath = mainFeedCollection.indexPath(for: feedCell) else { return }
    let post = posts[indexPath.row]
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let detailController = storyboard.instantiateViewController(identifier: "DetailViewController") { (coder) in
      return DetailViewController(coder: coder, post: post)
    }
    
    present(detailController, animated: true)
  }
  
  
}


