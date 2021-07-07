//
//  DetailViewController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var postController: PostController?
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.post?.title
        
        switch self.post?.media {
        case .image(image: let image):
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            self.view.addSubview(imageView)
            self.centerView(imageView)
        default:
            break
        }
    }
    
    private func centerView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
}
