//
//  PhotoController.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import Photos
import CoreImage

// MARK: - Types -
enum Filter: String, CaseIterable {
    case gaussian = "CIGaussianBlur"
    case contrast = "CIColorControls"
    case sepia = "CISepiaTone"
    case bloom = "CIBloom"
}

protocol PhotoUIDelegate: AVCapturePhotoCaptureDelegate {
    var photoFilterImageView: UIImageView! { get set }
    func updatePhoto(_ with: CGImage)
}

class PhotoController {
    // MARK: - Properties -
    private let context = CIContext(options: nil)
    private var filter: CIFilter?

    weak var delegate: PhotoUIDelegate?

    init(delegate: PhotoUIDelegate) {
        self.delegate = delegate
    }

    private var pickedImage: UIImage? {
        didSet {
            guard let originalImage = pickedImage else {
                scaledImage = nil
                //FIXME: alertUnknownEdgeCase()
                return
            }

            guard var scaledSize = delegate?.photoFilterImageView.bounds.size else { return }
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    ///the original image, scaled by the delegate's imageView
    private var scaledImage: UIImage? {
        didSet {
            filterImage()
        }
    }
    // MARK: - Filter Image -
    ///the scaled image as a CIImage for use in filtering operations
    private var inputImage: CIImage? {
        guard let scaledImage = scaledImage,
            let cgImage = scaledImage.cgImage else {
                //FIXME: alertUnknownEdgeCase()
                return nil
        }
        let ciImage = CIImage(cgImage: cgImage)
        return ciImage
    }

    func createFilter(with name: Filter){
        filter = CIFilter(name: name.rawValue)!
    }

    /// Filter the inputImage using the bloom filter given an intensity to increase the bloom effect, and a radius to scale the effect
    /// - Parameters:
    ///   - intensity: min: 0, max: 1
    ///   - radius: min: 0, max: ~20
    /// - Note: the effect doesn't appear to be relevant until an intensity of 0.5 and radius of 5
    func bloomFilter(intensity: Float, radius: Float) {
        createFilter(with: .gaussian)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(intensity, forKey: kCIInputIntensityKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        filterImage()
    }
    ///create a filteredImage and return it to the delegate to be used to update it's UI
    private func filterImage() {
        if let outputImage = filter?.outputImage,
            let image = scaledImage,
            let filteredImage = context.createCGImage(outputImage, from: CGRect(origin: .zero, size: image.size)) {
            DispatchQueue.main.async {
                self.delegate?.updatePhoto(filteredImage)
                //self.imageView.image = UIImage(cgImage: filteredImage)
            }
        }
    }

    // FIXME: Move to delegate
//    private func updateFilterUI() {
//        //it's easy to miss something when using a bool to switch states
//        //and there's no point in setting up a filter with no UI
//        guard !mainFilterStack.isHidden else {
//            alertUnknownEdgeCase()
//            return
//        }
//        switch filter.name {
//        case Filter.gaussian.rawValue:
//            setupGaussianFilter()
//        case Filter.checkerboard.rawValue:
//            setupCheckerboardFilter()
//        case Filter.contrast.rawValue:
//            setupColorControlsFilter()
//        case Filter.sepia.rawValue:
//            setupSepiaFilter()
//        case Filter.bloom.rawValue:
//            setupBloomFilter()
//        default:
//            break
//        }
//    }
}
