//
//  Experience.swift
//  Experiences
//
//  Created by Kenneth Jones on 11/16/20.
//

import Foundation
import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var id: String
    var expTitle: String
    var image: UIImage?
    var ratio: CGFloat?
    var recording: URL?
    let timestamp: Date
    var coordinate: CLLocationCoordinate2D
    
    
    init(expTitle: String, image: UIImage? = nil, ratio: CGFloat?, recording: URL? = nil, timestamp: Date = Date(), coordinate: CLLocationCoordinate2D) {
        self.id = UUID().uuidString
        self.expTitle = expTitle
        self.image = image
        self.ratio = ratio
        self.recording = recording
        self.timestamp = timestamp
        self.coordinate = coordinate
    }
}
