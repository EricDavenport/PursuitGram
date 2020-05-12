//
//  CreateItemController.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/9/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateItemController: UIViewController {
  
  @IBOutlet weak var userPostImageView: UIImageView!
  
  @IBOutlet weak var captionTextField: UITextField!
  
  private var storageService = StorageService()
  private let dbServices = DatabaseService()
  
  private var postedImage : UIImage? {
    didSet {
      userPostImageView.image = postedImage
    }
  }
  
  private lazy var imagePickerController : UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.delegate = self
    return picker
  }()
  
  private lazy var doubleTapGesture : UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer()
    gesture.numberOfTapsRequired = 2
    gesture.addTarget(self, action: #selector(showPhotoOptions))
    return gesture
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    captionTextField.delegate = self
    userPostImageView.isUserInteractionEnabled = true
    userPostImageView.addGestureRecognizer(doubleTapGesture)
    // Do any additional setup after loading the view.
  }
  
  @IBAction func postButtonPressed(_ sender: UIButton) {
    print("button pressed")
    guard let caption = captionTextField.text,
      !caption.isEmpty,
      let postedImage = postedImage else {
        self.showAlert(title: "Missing Fields", message: "Must include image and caption")
        return
    }
    
    guard let displayName = Auth.auth().currentUser?.displayName else {
      print("no display name")
      return
    }
    
    let resizedImage = UIImage.resizeImage(originalImage: postedImage, rect: userPostImageView.bounds)
    
    dbServices.createPost(caption: caption, displayName: displayName) { [weak self] (result) in
      switch result {
      case .failure(let error):
        DispatchQueue.main.async {
          self?.showAlert(title: "Error creating item", message: "\(error.localizedDescription)")
        }
        print("fail")
      case .success(let docID):
        self?.uploadPhoto(image: resizedImage, documentID: docID)
        print("success - doc created with \(docID)")
//        self?.showAlert(title: "Success", message: "Post created - \(docID)")
      }
    }
    
    
  }
  
  @objc private func showPhotoOptions() {
    let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
    let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
      self.imagePickerController.sourceType = .camera
      self.present(self.imagePickerController, animated: true)
    }
    
    let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
      self.imagePickerController.sourceType = .photoLibrary
      self.present(self.imagePickerController, animated: true)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alertController.addAction(cameraAction)
    }
    alertController.addAction(photoLibrary)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
  
  private func uploadPhoto(image: UIImage, documentID: String) {
    guard let user = Auth.auth().currentUser else { return }
    storageService.uploadPhoto(userEmail: user.email, docID: documentID, image: image) { [weak self] (result) in
      switch result {
      case .failure(let error):
        self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
      case .success(let url):
        self?.updatePostImageURL(url, documentID: documentID)
      }
    }
  }
  
  private func updatePostImageURL(_ url: URL, documentID: String) {
    Firestore.firestore().collection(DatabaseService.itemCollection).document(documentID).updateData(["imageURL" : url.absoluteString]) { [weak self] (error) in
      if let error = error {
        DispatchQueue.main.async {
          self?.showAlert(title: "Failed to post item", message: "\(error.localizedDescription)")
        }
      } else {
        DispatchQueue.main.async {
          self?.showAlert(title: "Success", message: "Posted to feed")
          self?.dismiss(animated: true)
        }
      }
    }
  }
  
  
  
  
}

extension CreateItemController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      fatalError("could not obtain original image")
    }
    
    postedImage = image
    dismiss(animated: true)
    
  }
}

extension CreateItemController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}
