//
//  UserExperience.swift
//  UserMediaExperiences
//
//  Created by Austin Cole on 2/22/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import MapKit

class UserExperience: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var audioURL: URL?
    var videoURL: URL?
    var imageData: Data?
    var title: String?
    
    init(audioURL: URL?, videoURL: URL?, imageData: Data?, title: String?, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.imageData = imageData
        self.title = title
    }

}
