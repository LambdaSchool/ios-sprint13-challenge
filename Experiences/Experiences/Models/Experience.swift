//
//  Experience.swift
//  Experiences
//
//  Created by Bronson Mullens on 9/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {

    // MARK: - Properties
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var audioURL: URL?
    
    // MARK: - Initializers
    
    init(title: String, coordinate: CLLocationCoordinate2D, image: UIImage?, audioURL: URL?) {
        self.title = title
        self.coordinate = coordinate
        self.image = image
        self.audioURL = audioURL
    }
}
