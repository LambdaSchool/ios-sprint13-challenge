//
//  ImageViewController.swift
//  Experiences
//
//  Created by Chris Dobek on 6/7/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

protocol ImageSaveDelegate {
    func returnImageToSaveScreen(image: UIImage?)
}

struct Filter {
    let filterName: String
    var filterEffectValue: Any?
    var filterEffectValueName: String?
}

class ImageViewController: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var saveImageButton: UIButton!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    private var originalImage: UIImage? {
        didSet {
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
    var imageSaveDelegate: ImageSaveDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
    }
    
    private func setupInitialViews() {
        // add Image button
        addImageButton.backgroundColor = .systemGreen
        addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addImageButton.tintColor = .white
        addImageButton.layer.cornerRadius = addImageButton.frame.width / 2
        addImageButton.layer.masksToBounds = true
        // edit button
        editImageButton.alpha = 0
        editImageButton.layer.cornerRadius = 10
        // filter collection view
        filterCollectionView.alpha = 0
        filterCollectionView.keyboardDismissMode = .interactive
        // save button
        saveImageButton.alpha = 0
        saveImageButton.layer.cornerRadius = 10
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: the photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editImageButtonTapped(_ sender: UIButton) {
        isEditingImage.toggle()
        if isEditingImage {
            filterCollectionView.alpha = 1
            editImageButton.setTitle("Done!", for: .normal)
        } else {
            filterCollectionView.alpha = 0
            editImageButton.setTitle("Edit", for: .normal)
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
        // Scaled Image
        collectionViewCellImages.append(scaledImage)
        
        // Sepia Filter
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CISepiaTone",
                                                                                      filterEffectValue: 0.75,
                                                                                      filterEffectValueName: kCIInputIntensityKey))!)
        // Photo Effect Mono Filter
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CIPhotoEffectMono",
                                                                                      filterEffectValue: nil,
                                                                                      filterEffectValueName: nil))!)
        // Blue Filter
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CIGaussianBlur",
                                                                                      filterEffectValue: 5.0,
                                                                                      filterEffectValueName: kCIInputRadiusKey))!)
        // Commic Effect Filter
        collectionViewCellImages.append(applyFilter(scaledImage, filterEffect: Filter(filterName: "CIComicEffect",
                                                                                      filterEffectValue: nil,
                                                                                      filterEffectValueName: nil))!)
        filterCollectionView.reloadData()
    }
    
    @IBAction func saveImageButtonTapped(_ sender: UIButton) {
        imageSaveDelegate?.returnImageToSaveScreen(image: imageView.image)
        self.dismiss(animated: true)
    }
}
    
    
    // MARK: - Image Picker
    extension ImageViewController: UIImagePickerControllerDelegate {
        
        internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selectedImage = info[.originalImage] as? UIImage {
                originalImage = selectedImage
                imageView.image = scaledImage
                createCollectionViewCellImages()
            }
            dismiss(animated: true)
            if imageView.image != nil {
                editImageButton.alpha = 1
                saveImageButton.alpha = 1
            }
        }
        
        internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
        }
    }
    
// MARK: - Collection View
extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
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
