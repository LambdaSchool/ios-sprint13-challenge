//
//  ImageFilter.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class ImageFilter {
    
    class func apply(filter: CIFilter, for image: UIImage, context: CIContext) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let filteredCIImage = filter.outputImage else { return image }
        guard let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent) else { return image }
        
        return UIImage(cgImage: filteredCGImage)
    }
    
}
