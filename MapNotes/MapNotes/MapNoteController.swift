//
//  MapNoteController.swift
//  MapNotes
//
//  Created by Thomas Sabino-Benowitz on 7/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import MapKit

class MapNoteController {
    var Mapnotes: [MapNote] = []
    
    func createMapNote(title: String, coordinate: CLLocationCoordinate2D, audioURL: URL? = nil, imageData: Data? = nil) {
     
        
        let mapNote = MapNote(title: title, coordinate: coordinate, audioURL: audioURL, imageData: imageData)
        Mapnotes.append(mapNote)
    }
}
