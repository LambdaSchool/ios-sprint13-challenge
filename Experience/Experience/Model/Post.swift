//
//  post.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/9/20.
//

import UIKit
import MapKit

enum MediaType {
    case image(UIImage)
}

class Post: NSObject {
    
    let mediaType: MediaType
    let title: String?
    let latitude: Double
    let longitude: Double
    
    init(title: String, mediaType: MediaType, latitude: Double, longitude: Double) {
        self.title = title
        self.mediaType = mediaType
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Post: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
}



