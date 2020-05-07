//
//  SettingViewController.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var updateButton: UIButton!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  
  private let storageService = StorageService()
  
  private lazy var imagePickerController : UIImagePickerController = {
    let ip = UIImagePickerController()
    ip.delegate = self
    return ip
  }()
  
  private var profileImage : UIImage? {
    didSet {
      userImageView.image = profileImage
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.userImageView.roundView()
    updateUI()
  }
  
  @IBAction func updateButtonPressed(_ sender: UIButton) {
    
    guard let displayName = usernameTextField.text,
      !displayName.isEmpty,
      let profileImage = profileImage else {
        showAlert(title: "Missing fields", message: "All fields required:/nUser profile photo/nUsername")
        return
    }
    
    guard let user = Auth.auth().currentUser else { return }
    
    let resizedImage = UIImage.resizeImage(originalImage: profileImage, rect: userImageView.bounds)
    
    storageService.uploadPhoto(userEmail: user.email, itemId: nil, image: resizedImage) { (result) in
      switch result {
      case .failure(let error):
        DispatchQueue.main.async {
          self.showAlert(title: "Error", message: "Unable to save photo: \(error)")
        }
      case .success(let url):
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = displayName
        request?.photoURL = url
        request?.commitChanges(completion: { [unowned self] (error) in
          if let error = error {
            DispatchQueue.main.async {
              self.showAlert(title: "Error updating profile", message: "Error: \(error)")
            }
          } else {
            DispatchQueue.main.async {
              self.showAlert(title: "Profile updated", message: "Profile successfully updated")
            }
          }
        })
      }
    }
    
  }
  
  
  @IBAction func editButtonPressed(_ sender: UIButton) {
    
    let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
    
    let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
      self.imagePickerController.sourceType = .photoLibrary
      self.present(self.imagePickerController, animated: true)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    
    alertController.addAction(photoLibraryAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
    
  }
  
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    do {
      try Auth.auth().signOut()
      UIViewController.showViewController(storyboardName: "LoginViewController", viewControllerId: "LoginViewController")
    } catch {
      DispatchQueue.main.async {
        self.showAlert(title: "Error Signing out", message: "\(error.localizedDescription)")
      }
    }
    
  }
  
  private func updateUI() {
    userImageView.roundView()
    guard let user = Auth.auth().currentUser else { return }
    emailLabel.text = user.email
    userImageView.kf.setImage(with: user.photoURL)
    usernameTextField.text = user.displayName
  }
  
  
  
  
}


extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      return
    }
    profileImage = image
    dismiss(animated: true)
    
  }
}

extension ProfileViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
