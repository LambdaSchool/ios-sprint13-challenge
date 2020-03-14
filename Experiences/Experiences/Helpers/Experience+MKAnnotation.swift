//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by Michael on 3/14/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation
import MapKit

extension Experience: MKAnnotation {
    
    var title: String? {
        expTitle
    }
}
