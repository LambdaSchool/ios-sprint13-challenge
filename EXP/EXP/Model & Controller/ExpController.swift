//
//  ExpController.swift
//  Exp
//
//  Created by Madison Waters on 2/24/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation
import MapKit

class ExpController {
    
    private (set) var exps: [Exp] = []
    
    func addExp(exp: Exp) {
        exps.append(exp)
    }
    
    func placeAnExp(exp: Exp) -> Exp{
        
        let expLocation = exp.location
        var expCoordinate = exp.coordinate
        expCoordinate = CLLocationCoordinate2D(latitude: (expLocation.coordinate.latitude), longitude: (expLocation.coordinate.longitude))
        
        let newExp = Exp(location: expLocation, coordinate: expCoordinate, title: nil, audioURL: nil, videoURL: nil, image: nil)
        return newExp
    }
    
}
