//
//  Posts.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    //properties for your mapView. These will be internally accessbile and used to present the post onto the map.
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    //these properties are specific for adding audio, images, and titles to a post. 
    var title: String?
    var image: UIImage?
    var audio: URL?
}
