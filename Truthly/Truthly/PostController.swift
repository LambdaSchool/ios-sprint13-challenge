//
//  PostController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreLocation

class PostController {

    var posts = [Post]()

    func createPost(with title: String,
                    ofType mediaType: MediaType,
                    location geotag: CLLocationCoordinate2D?) {
        let post = Post(title: title,
                        mediaType: mediaType,
                        geotag: geotag)
        posts.append(post)
    }
}
