//
//  ImageProcessor.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageProcessor {
    
    static func desaturate(_ image: UIImage) -> UIImage? {
        let context = CIContext()
        let colorControlsFilter = CIFilter.colorControls()
        let flattenedImage = image.flattened
        guard let ciImage = CIImage(image: flattenedImage) else { return nil }
        colorControlsFilter.inputImage = ciImage
        colorControlsFilter.saturation = 0
        guard let outputImage = colorControlsFilter.outputImage else { return nil }
        guard let renderedCGImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: renderedCGImage)
    }
}
