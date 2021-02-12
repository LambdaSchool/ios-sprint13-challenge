//
//  post.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/9/20.
//

import UIKit
import MapKit

class Post: NSObject {
    
    let image: UIImage?
    let titleName: String
    let latitude: Double
    let longitude: Double
    
    init(titleName: String, image: UIImage, latitude: Double, longitude: Double) {
        self.titleName = titleName
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Post: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    var title: String? { titleName }
}

