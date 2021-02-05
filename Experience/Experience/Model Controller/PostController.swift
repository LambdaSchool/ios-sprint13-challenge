//
//  PostController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/9/20.
//

import UIKit

class PostController {
    
    static let shared = PostController()
    var posts: [Post] = []
    
    func createImagePost(with title: String, image: MediaType, latitude: Double, longitude: Double) {
        let post = Post(title: title, mediaType: image, latitude: latitude, longitude: longitude, audioURL: nil)
        
        posts.append(post)
    }
    
    func createAudioPost(with title:String, audoURL: URL, latitude: Double, longitude: Double) {
        let post = Post(title: title, mediaType: nil, latitude: latitude, longitude: longitude, audioURL: audoURL)
        posts.append(post)
    }
    
}
