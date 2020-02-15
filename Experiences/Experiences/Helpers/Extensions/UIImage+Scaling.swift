//
//  UIImage+Scaling.swift
//  iOS8-PhotoFilter
//
//  Created by Paul Solt on 9/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Resize the image to a max dimension from size parameter
    func imageByScaling(toSize size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else { return nil }
        
        let originalAspectRatio = self.size.width/self.size.height
        var correctedSize = size
        
        if correctedSize.width > correctedSize.width*originalAspectRatio {
            correctedSize.width = correctedSize.width*originalAspectRatio
        } else {
            correctedSize.height = correctedSize.height/originalAspectRatio
        }
        
        return UIGraphicsImageRenderer(size: correctedSize, format: imageRendererFormat).image { context in
            DispatchQueue.main.async {
                self.draw(in: CGRect(origin: .zero, size: correctedSize))
            }
        }
    }
    
    /// Renders the image if the pixel data was rotated due to orientation of camera
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { context in
            draw(at: .zero)
        }
    }
    
    var ratio: CGFloat {
        return size.height / size.width
    }
    
    static func loadImageFromDocumentsDirectory(name: String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else { return nil }
        let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name).appendingPathExtension("png")
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
}
