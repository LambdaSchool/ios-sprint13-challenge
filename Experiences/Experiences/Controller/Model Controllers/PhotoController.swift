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

class PhotoController {
    // MARK: - Properties -
    private let context = CIContext(options: nil)
    private var filter: CIFilter?

    weak var delegate: PhotoUIDelegate?

    init(delegate: PhotoUIDelegate) {
        self.delegate = delegate
    }
    // MARK: - Image Processing -
    ///the scaled image as a CIImage for use in filtering operations
    func setImage(image: UIImage) {
        pickedImage = image
    }

    private var pickedImage: UIImage? {
        didSet {
            guard let pickedImage = pickedImage else {
                scaledImage = nil
                alertUser(
                    title: "An Unknown Error Occurred",
                    message: "Please restart the app and try again."
                )
                return
            }

            guard var scaledSize = delegate?.photoFilterImageView.bounds.size else { return }
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = pickedImage.imageByScaling(toSize: scaledSize)
        }
    }
    ///the original image, scaled by the delegate's imageView
    private var scaledImage: UIImage? {
        didSet {
            filterImage()
        }
    }

    // MARK: - Filter Image -
    private var inputImage: CIImage? {
        guard let scaledImage = scaledImage,
            let cgImage = scaledImage.cgImage else {
                alertUser(
                    title: "An Unknown Error Occurred",
                    message: "Please restart the app and try again."
                )
                return nil
        }
        let ciImage = CIImage(cgImage: cgImage)
        return ciImage
    }


    // MARK: - Exposed methods -
    func createFilter(with name: Filter){
        filter = CIFilter(name: name.rawValue)!
    }

    /// FIlter the inputImage using the radius filter given a radius to scale the effect.
    /// - Parameter radius: min: 0, max: ~10
    /// - Note: Beyond radius 10 is possible
    func blurFilter(radius: Float) {
        createFilter(with: .gaussian)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)

        filterImage()
    }

    /// Filter the inputImage using the bloom filter given an intensity to increase the bloom effect, and a radius to scale the effect
    /// - Parameters:
    ///   - intensity: min: 0, max: 1
    ///   - radius: min: 0, max: ~20
    /// - Note: the effect doesn't appear to be relevant until an intensity of 0.5 and radius of 5. Lower and higher values respectively are acceptable.
    func bloomFilter(intensity: Float, radius: Float) {
        createFilter(with: .bloom)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(intensity, forKey: kCIInputIntensityKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)

        filterImage()
    }

    /// Filter the inputImage's color using brightness, contrast, and saturation.
    /// - Parameters:
    ///   - brightness: min: -1, max: 1
    ///   - contrast: min: ~0.25, max: ~4
    ///   - saturation: min: 0, max: ~2
    /// - Note: higher/lower values are available for contrast, and higher values are available for saturation. These levels appear to have the most effect
    func contrastFilter(brightness: Float, contrast: Float, saturation: Float) {
        createFilter(with: .contrast)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
        filter?.setValue(contrast, forKey: kCIInputContrastKey)
        filter?.setValue(saturation, forKey: kCIInputSaturationKey)

        filterImage()
    }

    /// FIlter the inputImage, making it varying degrees of Sepia
    /// - Note: There may be higher values available for intensity, but the image starts to turn bright orange
    /// - Parameter intensity: min: 0, max: ~2
    func sepiaFilter(intensity: Float) {
        createFilter(with: .sepia)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(intensity, forKey: kCIInputIntensityKey)
        filterImage()
    }

    // MARK: - Filter Implementation -
    
    ///create a filteredImage and return it to the delegate to be used to update it's UI
    private func filterImage() {
        if let outputImage = filter?.outputImage,
            let image = scaledImage?.flattened,
            let filteredImage = context.createCGImage(outputImage, from: CGRect(origin: .zero, size: image.size)) {
            DispatchQueue.main.async {
                self.delegate?.updatePhoto(filteredImage)
            }
        } else {
            //return the unfiltered Image
            // ... An unrelated delegate may have filtered the image and assigned it to this photoController instance
            guard let scaledImage = scaledImage,
                let flattenedImage = scaledImage.flattened.cgImage else { return }
            self.delegate?.updatePhoto(flattenedImage)
        }
    }
    // MARK: - UX -
    func requestPermissionAndPresentImagePicker() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
            delegate?.presentImagePickerController()
        case .notDetermined:

            PHPhotoLibrary.requestAuthorization { (status) in

                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                self.delegate?.presentImagePickerController()
            }

        case .denied:
            print("access to photo library denied")
            self.alertUser(
                title: "Oops, you denied access.",
                message: "In order to save your photo experience, we need to access photos in your Photo Library. A story experience may be more to your liking."
            )
        case .restricted:
            self.alertUser(
                title: "Parental Control Settings",
                message: "Your parental control settings do not currently allow us to access your photo library."
            )
            NSLog("access to photo library restricted - parental controls")

        @unknown default:
            print("FatalError")
        }
        delegate?.presentImagePickerController()
    }

    private func alertUser(title: String, message: String) {
        guard let delegate = self.delegate as? UIViewController else { return }
        Alert.show(title: title,
                   message: message,
                   vc: delegate)
        return
    }
}
