//
//  PostExperiences.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import MapKit

class PostExperiences: NSObject {
    
    let title: String?
    let author: String
    let location: CLLocationCoordinate2D
    let entry: String?
    let image: UIImage?
    let audioURL: URL?
    
    init(title: String?, author: String, location: CLLocationCoordinate2D, image: UIImage?, entry: String?, audioURL: URL?) {
        
        self.title = title ?? nil
        self.author = author
        self.location = location
        self.image = image ?? nil
        self.entry = entry ?? nil
        self.audioURL = audioURL ?? nil
    }
}
