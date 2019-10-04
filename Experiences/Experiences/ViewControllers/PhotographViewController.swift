//
//  PhotographViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class PhotographViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var takePhotoButton: UIButton!
	@IBOutlet var filterCollectionView: UICollectionView!
	@IBOutlet var strengthSlider: UISlider!

	lazy var filters: [CIFilter] = {
		[]
	}()
	private let context = CIContext(options: nil)
	var selectedFilter: CIFilter?

	private var collectionViewHeight: CGFloat {
		filterCollectionView.frame.size.height
	}
	private var originalImage: UIImage? {
		didSet {
			guard let image = originalImage else { return }
			let scale = UIScreen.main.scale
			var maxSize = imageView.bounds.size
			maxSize = CGSize(width: maxSize.width * scale, height: maxSize.height * scale)
			scaledImage = image.imageByScaling(toSize: maxSize)
			var collectionViewSize = CGSize(width: collectionViewHeight * scale, height: collectionViewHeight * scale)
			collectionViewImage = image.imageByScaling(toSize: collectionViewSize)
		}
	}

	private var scaledImage: UIImage? {
		didSet {
			updateImage()
		}
	}
	private var collectionViewImage: UIImage? {
		didSet {
			filterCollectionView.reloadData()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
	}

	
	private func updateImage() {
		if let image = scaledImage {
			imageView.image = filterImage(image)
		}
	}

	@IBAction func strengthSliderChanged(_ sender: UISlider) {
		updateImage()
	}

	func filterImage(_ image: UIImage) -> UIImage {
		guard let filter = selectedFilter, let ciImage = CIImage(image: image) else { return image }

		filter.setValue(ciImage, forKey: kCIInputImageKey)

		guard let ciImageResult = filter.outputImage, let cgImageResult = context.createCGImage(ciImageResult, from: CGRect(origin: .zero, size: image.size)) else { fatalError("No output image") }

		return UIImage(cgImage: cgImageResult)
	}

}

extension PhotographViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filters.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath)
		guard let filterCell = cell as? FilterCollectionViewCell else { return cell }

		filterCell.image = collectionViewImage
		filterCell.filter = filters[indexPath.item]
		return filterCell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionViewHeight, height: collectionViewHeight)
	}
}
