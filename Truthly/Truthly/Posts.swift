//
//  Posts.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Post: NSObject {
    //properties for your mapView. These will be internally accessbile and used to present the post onto the map.
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    //these properties are specific for adding audio, images, and titles to a post. 
    var title: String?
    var image: UIImage?
    var audio: URL?
    
    init(place: String, time: Date, latitude: Double, longitude: Double, title: String?, image: UIImage?, audio: URL?) {
        self.place = place
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.image = image
        self.audio = audio
    }
}

extension Post: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var subtitle: String? {
        if let title = title {
            return title
        } else {
            return "No Title"
        }
    }
    
    
}

