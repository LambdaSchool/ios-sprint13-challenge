//
//  PostController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import CoreLocation

class PostController {
    private(set) var posts: [Post] = []
    
    var currentLocation: CLLocation?
    var didChange: (([Post]) -> Void)?
    
    func savePost(_ post: Post) {
        if let coordinate = currentLocation?.coordinate {
            post.coordinate = coordinate
        }
            
        self.posts.append(post)
        
        // executing the closure above sending the array of Posts
        self.didChange?(self.posts)
    }
}
