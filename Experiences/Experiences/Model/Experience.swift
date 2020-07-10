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
  
  let newTitle: String
  let mediaType: MediaType
  let geoLocation: CLLocationCoordinate2D?
//  let video: URL?
//  let audio: URL?
  
  init(title: String, mediaType: MediaType, geoLocation: CLLocationCoordinate2D?) {
    self.newTitle = title
    self.mediaType = mediaType
    self.geoLocation = geoLocation
  }
}

