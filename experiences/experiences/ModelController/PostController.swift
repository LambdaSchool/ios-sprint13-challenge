//
//  PostController.swift
//  experiences
//
//  Created by Clayton Watkins on 9/11/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import MapKit

class PostController {
    
    static let shared = PostController()
    var posts: [Post] = []
    
    // Stored User Default that will keep track of our "logged in" user
    var currentUser: String? {
        UserDefaults.standard.string(forKey: "username")
    }
    
    func createImagePost(with title: String, image: UIImage, location: CLLocationCoordinate2D) {
        guard let currentUser = currentUser else { return }
        let post = Post(title: title, author: currentUser, location: location, image: image, entry: nil, audioURL: nil)
        posts.append(post)
    }
    
    func createTextPost(with title: String, entry: String, location: CLLocationCoordinate2D) {
        guard let currentUser = currentUser else { return }
        let post = Post(title: title, author: currentUser, location: location, image: nil, entry: entry, audioURL: nil)
        posts.append(post)
    }
    
    func createAudioPost(with title: String, audioURL: URL, location: CLLocationCoordinate2D) {
        guard let currentUser = currentUser else { return }
        let post = Post(title: title, author: currentUser, location: location, image: nil, entry: nil, audioURL: audioURL)
        posts.append(post)
    }
    
}
