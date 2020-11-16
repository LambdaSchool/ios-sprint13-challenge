//
//  Experience.swift
//  Experiences
//
//  Created by John McCants on 11/6/20.
//

import Foundation
import MapKit
import UIKit

class Experience: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let url: URL?
    let image: UIImage?
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, url: URL?, image: UIImage?) {
        self.title = title
        self.coordinate = coordinate
        self.url = url
        self.image = image
        
    }
}


