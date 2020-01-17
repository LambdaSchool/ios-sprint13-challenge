//
//  ImageFilterHelper.swift
//  Unit4Sprint1Challenge
//
//  Created by Jon Bash on 2020-01-17.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit
import CoreImage

class ImageFilterer {
    enum FilterType: String {
        case tonal = "CIPhotoEffectTonal"
        case noir = "CIPhotoEffectNoir"
        case transfer = "CIPhotoEffectTransfer"
        case fade = "CIPhotoEffectFade"
        case instant = "CIPhotoEffectInstant"
    }

    private var context = CIContext(options: nil)

    func filterImage(_ image: UIImage, withType filterType: FilterType) -> UIImage {
        guard let cgImage = image.cgImage
            else { return image }
        var ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(
            name: filterType.rawValue,
            parameters: [kCIInputImageKey: ciImage])
        if let filterOutput = filter?.outputImage {
            ciImage = filterOutput
        }
        guard let outputCGImage = context.createCGImage(
            ciImage,
            from: CGRect(
                origin: CGPoint.zero,
                size: image.size))
            else { return image }

        return UIImage(cgImage: outputCGImage)
    }
}
