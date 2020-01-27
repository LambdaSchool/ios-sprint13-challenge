//
//  Post.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import CoreLocation

enum Media {
    case video(url: URL)
    case audio(url: URL)
    case image(image: UIImage)
}

struct Post {
    let title: String
    let media: Media
    let coordinate: CLLocationCoordinate2D
}
