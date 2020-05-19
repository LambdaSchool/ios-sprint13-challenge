//
//  Experience.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//TODO: Add URL for media Audio and Video remove MediaType

enum MediaType: String {
  case image
  case audio
  case video
}

class Experience: NSObject {
  
  let title: String
  let mediaType: MediaType
  let geoLocation: CLLocationCoordinate2D?
//  let video: URL?
//  let audio: URL?
  
  init(title: String, mediaType: MediaType, geoLocation: CLLocationCoordinate2D?) {
    self.title = title
    self.mediaType = mediaType
    self.geoLocation = geoLocation
    super.init()
  }
  
  
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let location = self.geoLocation else { return CLLocationCoordinate2D()}
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    var title: String? {
        return name
    }
    
}
