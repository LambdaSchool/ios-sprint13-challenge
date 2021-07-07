//
//  Post.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum Media: Hashable {
    case video(url: URL)
    case audio(url: URL)
    case image(image: UIImage)
}

class Post: NSObject {
    let title: String?
    let media: Media
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, media: Media) {
        self.title = title
        self.media = media
        self.coordinate = CLLocationCoordinate2D()
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.title == rhs.title
    }
}

extension Post: MKAnnotation {}


