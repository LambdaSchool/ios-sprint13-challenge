//
//  UIImage + Scaling.swift
//  Experiences
//
//  Created by Alex Thompson on 5/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

extension UIImage {
    var ratio: CGFloat {
        return size.height / size.width
    }
    
    func imageByScaling(toSize: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else { return nil }
        
        let originalAspectRatio = self.size.width / self.size.height
        var correctedSize = size
        
        if correctedSize.width > correctedSize.width * originalAspectRatio {
            correctedSize.width = correctedSize.width * originalAspectRatio
            
        } else {
            correctedSize.height = correctedSize.height / originalAspectRatio
        }
        
        return UIGraphicsImageRenderer(size: correctedSize, format: imageRendererFormat).image { context in
            draw(in: CGRect(origin: .zero, size: correctedSize))
        }
    }
}
