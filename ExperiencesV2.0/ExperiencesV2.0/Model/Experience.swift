//
//  Experience.swift
//  ExperiencesV2.0
//
//  Created by Joshua Rutkowski on 5/20/20.
//  Copyright © 2020 Rutkowski. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D {  return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)  }
          
    var title: String? {   return postTitle }
       
      
    let postTitle:String
    let postURL: URL?
    let latitude: Double
    let longitude: Double
    
    init(postTitle:String, postURL:URL?,latitude: Double, longitude: Double) {
        self.postTitle = postTitle
        self.postURL = postURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
