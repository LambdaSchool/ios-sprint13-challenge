//
//  MapNote.swift
//  MapNotes
//
//  Created by Thomas Sabino-Benowitz on 7/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import MapKit


class MapNote: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var audioURL: URL?
    var imageData: Data?
    
    init(title: String, coordinate: CLLocationCoordinate2D, audioURL: URL? = nil, imageData: Data? = nil){
        self.title = title
        self.coordinate = coordinate
        self.audioURL = audioURL
        self.imageData = imageData
    }
}
