//
//  Experience.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class Experience: NSObject, MKAnnotation
{
    var experienceTitle: String?
    var audioURL: URL?
    var videoURL: URL?
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, audioURL: URL, videoURL: URL, image: UIImage, coordinate: CLLocationCoordinate2D)
    {
        self.experienceTitle = title
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.image = image
        self.coordinate = coordinate
    }
}



