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
  let locationManager = CLLocationManager()
  var experiences = [Experience]()
  
  //Dummy init
  init() {
  createExperience(withTitle: "Running at the park", image: UIImage(imageLiteralResourceName: "plant2"), ofType: .image, location: locationManager.location?.coordinate)
     
  }
  
  
  func createExperience(withTitle title: String, image: UIImage?, ofType mediaType: MediaType, location geolocation: CLLocationCoordinate2D?) {
    let experience = Experience(title: title, image: image, mediaType: mediaType, geoLocation: geolocation)
    experiences.append(experience)
  }
}

