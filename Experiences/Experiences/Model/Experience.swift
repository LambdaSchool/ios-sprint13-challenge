//
//  Experience.swift
//  Experiences
//
//  Created by Norlan Tibanear on 11/16/20.
//

import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var title: String?
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
    var ratio: CGFloat?
    var audio: URL?
    var timestamp: Date
    
    
    init(title: String?, image: UIImage? = nil, coordinate: CLLocationCoordinate2D, ratio: CGFloat? = nil, audio: URL? = nil, timestamp: Date = Date()) {
        self.title = title
        self.image = image
        self.coordinate = coordinate
        self.ratio = ratio
        self.audio = audio
        self.timestamp = timestamp
    }
    
}

