//
//  Experience.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var ratio: CGFloat?
    var audioURL: URL?
    var videoURL: URL?
    var timestamp: Date
    
    init(title: String?, coordinate: CLLocationCoordinate2D, image: UIImage? = nil, ratio: CGFloat? = nil, audioURL: URL? = nil, videoURL: URL? = nil, timestamp: Date = Date()) {
        self.title = title
        self.coordinate = coordinate
        self.image = image
        self.ratio = ratio
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.timestamp = timestamp
    }
}
