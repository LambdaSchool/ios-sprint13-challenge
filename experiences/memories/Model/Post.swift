//
//  Post.swift
//  memories
//
//  Created by Clayton Watkins on 9/10/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import MapKit

class Post: NSObject {
    
    let image: UIImage?
    let author: String
    let title: String?
    let audioURL: URL?
    let location: CLLocationCoordinate2D
    let entry: String?
    
    init(title: String?, author: String, location: CLLocationCoordinate2D, image: UIImage?, entry: String?, audioURL: URL?) {
        self.title = title ?? nil
        self.author = author
        self.location = location
        self.image = image ?? nil
        self.entry = entry ?? nil
        self.audioURL = audioURL ?? nil
    }
}
