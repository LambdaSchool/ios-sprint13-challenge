//
//  Entry.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//
import CoreLocation
import Foundation

enum MeidaType: String {
    case image
    case audio
    case video
}

class Entry: NSObject {
    
    var entryTitle: String?
    let mediaType: MeidaType
    var geoTag: CLLocationCoordinate2D?
    
     init(entryTitle: String?, mediaType: MeidaType, geoTag: CLLocationCoordinate2D?) {
        self.entryTitle = entryTitle
        self.mediaType = mediaType
        self.geoTag = geoTag
    }
}
