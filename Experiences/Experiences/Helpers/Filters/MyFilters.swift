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
}

class SepiaFilter: MyFilter {
	var inputImage: CIImage?
	var strength: Double = 1
	var outputImage: CIImage? {
		return filterImage()
	}

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

	init(inputImage: CIImage? = nil) {
		self.inputImage = inputImage
	}

	private func filterImage() -> CIImage? {
		return inputImage
	}
}

//class ComicBookFilter: MyFilter
