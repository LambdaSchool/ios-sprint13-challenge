//
//  EntryController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import CoreLocation
import Foundation

class EntryController {
    var entries = [Entry]()
    static var shared = EntryController()
    
    func createPost(with title: String, ofType mediaType: MeidaType, location geoTag: CLLocationCoordinate2D?) {
        let entry = Entry(entryTitle: title, mediaType: mediaType, geoTag: geoTag)
        entries.append(entry)
    }
}
