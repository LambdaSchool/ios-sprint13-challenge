//
//  PostAnnotation.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import Foundation
import MapKit
class PostAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!)
    }
    
    var title: String? {
        post.title
    }
    let post: Post
    
    init(post: Post) {
        self.post = post
    }
}
