//
//  Experience.swift
//  Experiences
//
//  Created by Jordan Christensen on 11/2/19.
//  Copyright © 2019 Mazjap Co. All rights reserved.
//

import UIKit
import CoreLocation

class Experience: NSObject {
    let title: String
    let image: UIImage
    var audio: URL?
    var video: URL?
    var geotag: CLLocationCoordinate2D?
    
    init(title: String, image: UIImage, audio: URL? = nil, video: URL? = nil, geotag: CLLocationCoordinate2D? = nil) {
        self.title = title
        self.image = image
        self.audio = audio
        self.video = video
        self.geotag = geotag
    }
}
