//
//  Constants.swift
//  Experiences
//
//  Created by David Wright on 5/17/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import MapKit

struct DW {
    static let buttonCornerRadius: CGFloat = 4.0
}

struct SegueIdentifiers {
    static let addExperienceSegue: String = "AddExperienceSegue"
    static let addImageSegue: String = "AddImageSegue"
    static let addAudioSegue: String = "AddAudioSegue"
    static let addVideoSegue: String = "AddVideoSegue"
}

struct ReuseIdentifiers {
    static let annotation = "ExperienceAnnotationView"
}

struct Locations {
    static let applePark = CLLocationCoordinate2D(latitude: 37.332914,
                                                  longitude: -122.005202)
}
