//
//  Experience.swift
//  Experiences
//
//  Created by Aaron Cleveland on 3/13/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var id: String
    
    var audioURL: URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent("\(id)audio").appendingPathExtension("caf")
    }
    
    var videoURL: URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent("\(id)video").appendingPathExtension("mov")
    }
    
    init(title: String, image: UIImage?, coordinate: CLLocationCoordinate2D, id: String) {
        self.title = title
        self.image = image
        self.coordinate = coordinate
        self.id = id
    }
}
