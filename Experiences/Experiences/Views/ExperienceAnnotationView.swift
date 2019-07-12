//
//  ExperienceAnnotationView.swift
//  Experiences
//
//  Created by Christopher Aronson on 7/12/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import MapKit

class ExperienceAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            
            if let experienceAnnotation = newValue as? Experience {
                
                canShowCallout = true
                
                let imageView = UIImageView(image: experienceAnnotation.image.resized(toWidth: 150))
                
                
                detailCalloutAccessoryView = imageView
            }
        }
    }

}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
