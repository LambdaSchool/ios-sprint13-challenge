//
//  Experience.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject,  MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var audio: URL?
    var video: URL?
    var image: UIImage?

    init(title: String, audio: URL?, image: UIImage?, video: URL?, coordinate: CLLocationCoordinate2D) {

        self.title = title
        self.audio = audio
        self.video = video
        self.image = image
        self.coordinate = coordinate


    }





}
