//
//  CreatePostViewController.swift
//  ExperiencesSprint
//
//  Created by Jarren Campos on 7/17/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    var currentPost: Post!
    var alertController = AlertController()
    
    var currentPicture: UIImage!
    
    @IBOutlet var thumbnailPicture: UIImageView!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var playAudioButton: UIButton!
    @IBOutlet var rerecordAudioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailPicture.image = currentPicture
        #warning("Need to avoid this hardcoded workaround")
        playAudioButton.alpha = 0
        rerecordAudioButton.alpha = 0
    }
    private func presentFailureAlert(title: String, message: String) {
          present(alertController.basicAlertController(title: title, message: message, selection: "OK"), animated: true, completion: nil)
      }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        if commentTextView.text != "" {
            currentPost = Post(image: currentPicture, title: commentTextView.text)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if commentTextView.text == "" {
            presentFailureAlert(title: "Failure To Post", message: "Please add a comment")
        } else {
            let destVC = segue.destination as! MapKitHomeViewController
            destVC.postItem.image = currentPicture
            destVC.postItem.title = commentTextView.text
            destVC.helperInt += 1
        }
    }
}
