//
//  FilterController.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/11/20.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterController {
    
    //MARK: - Properties -
    
    let context = CIContext()
    
    let bokehFilter = CIFilter.bokehBlur()
    let hueFilter = CIFilter.hueAdjust()
    let vignetteFilter = CIFilter.vignette()
    let xrayFilter = CIFilter.xRay()
    let sepiaFilter = CIFilter.sepiaTone()
    
    //MARK: - Methods -
    
    //this returns an image with the bokeh blur filter applied with the desired attributes
    func applyBokehFilter(image: UIImage, radius: Float, ringAmount: Float, ringSize: Float, softness: Float) -> UIImage? {
        
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        bokehFilter.setValue(ciImage, forKey: "inputImage")
        bokehFilter.radius = radius
        bokehFilter.ringAmount = ringAmount
        bokehFilter.ringSize = ringSize
        bokehFilter.softness = softness
        
        guard let outputCIImage = bokehFilter.outputImage?.clampedToExtent() else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: ciImage.extent) else { return nil }
        let outputImage = UIImage(cgImage: outputCGImage)
        
        return outputImage
    }
    
    //this returns an image with the hue filter applied with the desired attributes
    func applyHueFilter(image: UIImage, angle: Float) -> UIImage? {
        
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        hueFilter.setValue(ciImage, forKey: "inputImage")
        hueFilter.angle = angle
        
        guard let outputCIImage = hueFilter.outputImage?.clampedToExtent() else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    //this returns an image with the Vignette filter applied
    func applyVignetteFilter(image: UIImage, intensity: Float, radius: Float) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        vignetteFilter.setValue(ciImage, forKey: "inputImage")
        vignetteFilter.intensity = intensity
        vignetteFilter.radius = radius
        
        guard let outputCIImage = vignetteFilter.outputImage else { return nil }
        guard let outputCGImage =  context.createCGImage(outputCIImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }

    //this returns an image with the X-Ray filter applied to it
    func applyXRayFilter(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        xrayFilter.setValue(ciImage, forKey: "inputImage")
        
        guard let outputCIImage = xrayFilter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    //this returns an image with the Sepia tone filter applied with the desired intensity
    func applySepiaFilter(image: UIImage, intensity: Float) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        sepiaFilter.setValue(ciImage, forKey: "inputImage")
        sepiaFilter.intensity = intensity
        
        guard let outputCIImage = sepiaFilter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
}//End of class
