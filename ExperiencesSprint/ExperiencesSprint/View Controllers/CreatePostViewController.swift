//
//  CreatePostViewController.swift
//  ExperiencesSprint
//
//  Created by Jarren Campos on 7/17/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    var currentPicture: UIImage!
    
    @IBOutlet var thumbnailPicture: UIImageView!
    @IBOutlet var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailPicture.image = currentPicture
    }
}
