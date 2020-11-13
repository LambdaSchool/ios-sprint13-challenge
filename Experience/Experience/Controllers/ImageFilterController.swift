//
//  ImageFilterController.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins


struct ImageFilterController {
    
    let context = CIContext()
    let vignetteFilter = CIFilter.vignette()
    let hueFilter = CIFilter.hueAdjust()
    
    func addVignetteFilter(image: UIImage, intensity: Float, radius: Float) -> UIImage? {
        guard let cgimage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgimage)
        
        vignetteFilter.setValue(ciImage, forKey: "inputImage")
        vignetteFilter.intensity = intensity
        vignetteFilter.radius = radius
        
        guard let outputCIImage = vignetteFilter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func applyHueFilter(image: UIImage, angle: Float) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        hueFilter.setValue(ciImage, forKey: "inputImage")
        hueFilter.angle = angle
        
        guard let outputCIImage = hueFilter.outputImage?.clampedToExtent() else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }

}
