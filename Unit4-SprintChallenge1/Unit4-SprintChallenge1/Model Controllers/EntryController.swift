//
//  EntryController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreLocation
class EntryController {

    static let shared = EntryController()

    var entries = [Entry]()

    func createPost(with title: String, ofType mediaType: MediaType, location geotag: CLLocationCoordinate2D?) {
        let entry = Entry(title: title, mediaType: mediaType, geotag: geotag)
        entries.append(entry)
    }

    
}
