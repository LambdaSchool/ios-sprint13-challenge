//
//  Experience.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject {

    let id = UUID()
    let title: String? // MKAnnotation wants an optional `title`
    let image: UIImage?
    let audioURL: URL?
    let location: CLLocationCoordinate2D

    init(title: String, image: UIImage?, audioURL: URL?, location: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.audioURL = audioURL
        self.location = location
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Experience else { return false }

        return self.id == object.id
    }

    override var hash: Int {
        id.hashValue
    }
}

extension Experience: MKAnnotation {

    var coordinate: CLLocationCoordinate2D { location }

    //var title: String? { /* defined above */ }
}
