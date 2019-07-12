//
//  Experience.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {

    var title: String?
    var audio: URL?
    var video: URL?
    var image: UIImage?
    var location: CLLocationCoordinate2D

    init(title: String?, audio: URL?, image: UIImage?, video: URL?, location: CLLocationCoordinate2D) {

        self.title = title
        self.audio = audio
        self.video = video
        self.image = image
        self.location = location


    }

    var coordinate: CLLocationCoordinate2D {
        return self.coordinate
    }




}
