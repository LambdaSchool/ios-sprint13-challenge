//
//  MyFilters.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import CoreImage

protocol MyFilter: AnyObject {
	var inputImage: CIImage? { get set }
	var strength: Double { get set }
	var outputImage: CIImage? { get }
	var maxValue: Float { get }
}

class SepiaFilter: MyFilter {
	var inputImage: CIImage?
	var strength: Double = 1
	var outputImage: CIImage? {
		return filterImage()
	}
	let maxValue: Float = 2

	init(inputImage: CIImage? = nil) {
		self.inputImage = inputImage
	}

	private func filterImage() -> CIImage? {
		let sepiaFilter = CIFilter(name: "CISepiaTone")

		sepiaFilter?.setValue(inputImage, forKey: kCIInputImageKey)
		sepiaFilter?.setValue(strength * 0.5 as NSNumber, forKey: kCIInputIntensityKey)

		let vingette = CIFilter(name: "CIVignette")

		vingette?.setValue(sepiaFilter?.outputImage, forKey: kCIInputImageKey)
		vingette?.setValue(strength, forKey: kCIInputIntensityKey)
		vingette?.setValue(strength * 2, forKey: kCIInputRadiusKey)

		return vingette?.outputImage
	}
}

class DreamFilter: MyFilter {
	var inputImage: CIImage?
	var strength: Double = 1
	var outputImage: CIImage? {
		return filterImage()
	}
	let maxValue: Float = 2

	init(inputImage: CIImage? = nil) {
		self.inputImage = inputImage
	}

	private func filterImage() -> CIImage? {
		let bloomFilter = CIFilter(name: "CIBloom")

		bloomFilter?.setValue(inputImage, forKey: kCIInputImageKey)
		bloomFilter?.setValue(strength * 14.43 as NSNumber, forKey: kCIInputIntensityKey)
		bloomFilter?.setValue(strength * 0.5835 as NSNumber, forKey: kCIInputRadiusKey)

		let vibranceFilter = CIFilter(name: "CIVibrance")

		vibranceFilter?.setValue(bloomFilter?.outputImage, forKey: kCIInputImageKey)
		vibranceFilter?.setValue(strength * 0.6967, forKey: kCIInputAmountKey)

		return vibranceFilter?.outputImage
	}
}

//class VibranceFilter: MyFilter

class HashtagNoFilter: MyFilter {
	var inputImage: CIImage?
	var strength: Double = 1
	var outputImage: CIImage? {
		return filterImage()
	}
	let maxValue: Float = 1

	init(inputImage: CIImage? = nil) {
		self.inputImage = inputImage
	}

	private func filterImage() -> CIImage? {
		return inputImage
	}
}

class InstantFilter: MyFilter {
	var inputImage: CIImage?
	var strength: Double = 1
	var outputImage: CIImage? {
		return filterImage()
	}
	let maxValue: Float = 1

	init(inputImage: CIImage? = nil) {
		self.inputImage = inputImage
	}

	private func filterImage() -> CIImage? {
		let instantFilter = CIFilter(name: "CIPhotoEffectInstant")

		instantFilter?.setValue(inputImage, forKey: kCIInputImageKey)

		let opacityFilter = CIFilter(name: "CIConstantColorGenerator")
		let color = CIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(strength))
		opacityFilter?.setValue(color, forKey: kCIInputColorKey)

		let overComposite = CIFilter(name: "CIBlendWithAlphaMask")
		overComposite?.setValue(instantFilter?.outputImage, forKey: kCIInputImageKey)
		overComposite?.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
		overComposite?.setValue(opacityFilter?.outputImage, forKey: kCIInputMaskImageKey)

		return overComposite?.outputImage
	}
}

//class ComicBookFilter: MyFilter
