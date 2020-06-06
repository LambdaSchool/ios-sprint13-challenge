//
//  PhotoViewController.swift
//  Experiences
//
//  Created by Shawn James on 6/5/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct Filter {
    let filterName: String
    var filterEffectValue: Any?
    var filterEffectValueName: String?
}

class PhotoViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var savePhotoButton: UIButton!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    private var originalImage: UIImage? {
        didSet {
            // 414*3 = 1,242 pixels (portrait mode for iphone 11 pro max)
            guard let originalImage = originalImage else {
                scaledImage = nil // clear out image if set to nil
                return
            }
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    private var scaledImage: UIImage?
    private let context = CIContext(options: nil)
    private var collectionViewCellImages = [UIImage]()
    private var isEditingImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
    }
    
    private func setupInitialViews() {
        // add photo button
        addPhotoButton.backgroundColor = .systemBlue
        addPhotoButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addPhotoButton.tintColor = .white
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        // edit button
        editPhotoButton.alpha = 0
        editPhotoButton.layer.cornerRadius = 10
        // filter collection view
        filterCollectionView.alpha = 0
        filterCollectionView.keyboardDismissMode = .interactive
        // save button
        savePhotoButton.alpha = 0
        savePhotoButton.layer.cornerRadius = 10
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return print("Error: saved photos not responding") }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func editPhotonButtonTapped(_ sender: UIButton) {
        isEditingImage.toggle()
        if isEditingImage {
            filterCollectionView.alpha = 1
            editPhotoButton.setTitle("Done!", for: .normal)
        } else {
            filterCollectionView.alpha = 0
            editPhotoButton.setTitle("Edit", for: .normal)
        }
    }
    
    private func applyFilter(_ image: UIImage, filterEffect: Filter) -> UIImage? {
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        // apply filters
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filterEffectValue = filterEffect.filterEffectValue,
            let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        var filteredImage: UIImage?
        // CIImage -> CGImage -> UIImage
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgiImageResult = context.createCGImage(output, from: output.extent) {
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        return filteredImage
    }
    
    private func createCollectionViewCellImages() {
        guard let scaledImage = scaledImage else { return }
        // 0
        collectionViewCellImages.append(scaledImage)
        // 1
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CISepiaTone",
                                                                                      filterEffectValue: 0.75,
                                                                                      filterEffectValueName: kCIInputIntensityKey))!)
        // 2
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CIPhotoEffectProcess",
                                                                                      filterEffectValue: nil,
                                                                                      filterEffectValueName: nil))!)
        // 3
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CIGaussianBlur",
                                                                                      filterEffectValue: 5.0,
                                                                                      filterEffectValueName: kCIInputRadiusKey))!)
        // 4
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CIPhotoEffectNoir",
                                                                                      filterEffectValue: nil,
                                                                                      filterEffectValueName: nil))!)
        filterCollectionView.reloadData()
    }
    
    @IBAction func savePhotoButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("Save button tapped")
        }
    }
    
}

// MARK: - Image Picker
extension PhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            originalImage = selectedImage
            imageView.image = scaledImage
            createCollectionViewCellImages()
        }
        dismiss(animated: true)
        if imageView.image != nil {
            editPhotoButton.alpha = 1
            savePhotoButton.alpha = 1
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - Collection View
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .systemRed
        if originalImage != nil { cell.imageView.image = collectionViewCellImages[indexPath.row] }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // go inside the cell, and set it's image to the main image view
        imageView.image = collectionViewCellImages[indexPath.row]
    }
}

extension UIImage {
    /// Resize the image to a max dimension from size parameter
    func imageByScaling(toSize size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else { return nil }
        
        let originalAspectRatio = self.size.width/self.size.height
        var correctedSize = size
        
        if correctedSize.width > correctedSize.width*originalAspectRatio {
            correctedSize.width = correctedSize.width*originalAspectRatio
        } else {
            correctedSize.height = correctedSize.height/originalAspectRatio
        }
        
        return UIGraphicsImageRenderer(size: correctedSize, format: imageRendererFormat).image { context in
            draw(in: CGRect(origin: .zero, size: correctedSize))
        }
    }
}
