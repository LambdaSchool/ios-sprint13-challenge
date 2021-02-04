//
//  PostController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/9/20.
//

import UIKit

class PostController {
    
    var posts: [Post] = []
    
    func createPosterPost(with title: String, image: MediaType, latitude: Double, longitude: Double) {
        
        let post = Post(title: title, mediaType: image, latitude: latitude, longitude: longitude)
        
        posts.append(post)
    }
}
