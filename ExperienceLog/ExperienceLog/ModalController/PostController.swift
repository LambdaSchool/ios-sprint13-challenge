//
//  PostController.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class PostController {
    
    var posts: [Post] = []
    
    func createNewPost(title: String, image: UIImage?, videoURL: URL?, audioURL: URL?, latitude: Double?, longitude: Double?, note: String?) {
        
        let post = Post(title: title, image: image, videoURL: videoURL, audioURL: audioURL, latitude: latitude, longitude: longitude, note: note)
        posts.append(post)
    }
}
