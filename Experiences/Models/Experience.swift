//
//  Experience.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Experience: NSObject {
    var video: URL?
    var image: UIImage?
    var title: String?
    var note: String?
//    var latitude: Double
//    var longitude: Double
    var geotag: CLLocationCoordinate2D?
    
//    required init(video: URL?, image: UIImage?, title: String, note: String?, latitude: Double, longitude: Double) {
    required init(video: URL?, image: UIImage?, title: String, note: String?, geotag: CLLocationCoordinate2D?) {
        self.title = title
        self.note = note
        self.video = video
        self.image = image
//        self.latitude = latitude
//        self.longitude = longitude
        self.geotag = geotag
        
        super.init()
    }
}
