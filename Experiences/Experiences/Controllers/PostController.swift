//
//  PostController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation

class PostController {
    var posts: [Post] = []
    
    func savePost(_ post: Post) {
        self.posts.append(post)
    }
}
