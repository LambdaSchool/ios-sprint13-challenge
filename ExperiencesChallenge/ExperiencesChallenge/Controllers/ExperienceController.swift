//
//  ExperienceController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//


import Foundation
import MapKit

class ExperienceController {

    var experiences = [Experience]()

    func createPost(with title: String, ofType mediaType: MediaType, location geotag: CLLocationCoordinate2D?) {
        let experience = Experience(title: title, mediaType: mediaType, geotag: geotag)
        experiences.append(experience)
    }


}
