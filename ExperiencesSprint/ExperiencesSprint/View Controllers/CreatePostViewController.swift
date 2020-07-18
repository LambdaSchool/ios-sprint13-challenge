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
    
    var currentPicture: UIImage!
    
    @IBOutlet var thumbnailPicture: UIImageView!
    @IBOutlet var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailPicture.image = currentPicture
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        currentPost = Post(image: currentPicture, title: commentTextView.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! MapKitHomeViewController
        destVC.postItem.image = currentPicture
        destVC.postItem.title = commentTextView.text
        destVC.helperInt += 1
    }
}
