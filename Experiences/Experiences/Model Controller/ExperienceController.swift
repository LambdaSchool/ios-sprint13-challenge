//
//  ExperienceController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperienceController {
  var experiences = [Experience]()
    
  func createExperience(withTitle title: String, ofType mediaType: MediaType, location geolocation: CLLocationCoordinate2D?) {
    let experience = Experience(title: title, mediaType: mediaType, geoLocation: geolocation)
    experiences.append(experience)
  }
}

