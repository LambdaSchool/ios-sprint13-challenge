//
//  UserExperienceViewController.swift
//  UX
//
//  Created by Nick Nguyen on 4/10/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation
import CoreLocation

protocol UserExperienceViewControllerDelegate: AnyObject {
    func didGetNewItem(item: [Item])
}

class UserExperienceViewController: UIViewController, UIGestureRecognizerDelegate
{
    var locationManager: CLLocationManager?
    weak var delegate: UserExperienceViewControllerDelegate?
    private var context = CIContext(options: nil)
    var items: [Item] = []
    private var originalImage: UIImage? {
         didSet {
           
             guard let originalImage = originalImage else { return }
             var scaledSize = imageView.bounds.size
             let scale = UIScreen.main.scale
            
             print("image size: \(originalImage.size)")
             print("size: \(scaledSize)")
             print("scale: \(scale)")
             scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
             scaledImage = originalImage.imageByScaling(toSize: scaledSize)
         }
     }
    
    private var scaledImage: UIImage? {
          didSet {
              updateViews()
          }
      }
  
    
    
    private let titleTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Title..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .bezel
        textField.becomeFirstResponder()
        return textField
    }()
    
    lazy private var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "camera"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
        
    }()
    private func filterColorInvert(_ image: UIImage) -> UIImage? {
          guard let cgImage = image.cgImage else { return nil }
          let ciImage = CIImage(cgImage: cgImage)
          let filter = CIFilter.colorInvert()
          
          
          filter.inputImage = ciImage
          
          guard let outputCIImage = filter.outputImage else { return nil }
          guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size) ) else { return nil }
                
                return UIImage(cgImage: outputCGImage)
      }
      private func filterComicImage(_ image: UIImage) -> UIImage? {
          guard let cgImage = image.cgImage else { return nil }
          
          let ciImage = CIImage(cgImage: cgImage)
          let filter = CIFilter.comicEffect()
           
             filter.setValue(ciImage, forKey: kCIInputImageKey)
        
          guard let outputCIImage = filter.outputImage else { return nil }
          
          guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size) ) else { return nil }
          
          return UIImage(cgImage: outputCGImage)
      }
    
    @objc func cameraPicked(sender: UITapGestureRecognizer) {
        
        showImagePickerControllerActionSheet()
    }
    private let filterSegmentControl: UISegmentedControl = {
        let items = ["Standard","Comic","Invert"]
       let sg = UISegmentedControl(items: items)
        sg.translatesAutoresizingMaskIntoConstraints = false
        sg.addTarget(self, action: #selector(segmentSwitch), for: .valueChanged)
        sg.selectedSegmentIndex =  0
        return sg
    }()
    
    @objc func segmentSwitch(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
            case 0:
                imageView.image = scaledImage
            case 1:
                 guard let imageToFiler = scaledImage else { return }
                imageView.image = filterComicImage(imageToFiler)
           
            case 2:
                guard let imageToFiler = scaledImage else { return }
                imageView.image = filterColorInvert(imageToFiler)
            default:
            break
        }
       
    }
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleTextField)
        view.addSubview(imageView)
        view.addSubview(filterSegmentControl)
        hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self, action: #selector(cameraPicked))
        tap.delegate = self
        imageView.addGestureRecognizer(tap)
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        view.backgroundColor = .white
        setUpNavigationBar()
        contrainstViews()
        originalImage = imageView.image
    }
    
    func updateViews() {
        imageView.image = scaledImage
    }
//
    
    private func contrainstViews() {
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        ])
        
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor,constant: 32),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        
        ])
        
        NSLayoutConstraint.activate([
            filterSegmentControl.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            filterSegmentControl.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            filterSegmentControl.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -32)
        
        ])
        
    }
    @objc func handleBack() {
          dismiss(animated: true, completion: nil)
      }
      
      @objc func handleNext() {
          dismiss(animated: true, completion: nil)
        let item = Item(postTitle: titleTextField.text!, postURL: nil, latitude:MapViewController.locationManager.location!.coordinate.latitude , longitude: MapViewController.locationManager.location!.coordinate.longitude)
        items.append(item)
        delegate?.didGetNewItem(item:items)
      }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "New Experience"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleNext))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
    }
    let videoRecordingViewController : UINavigationController = {
             let vc = VideoRecordingViewController()
             let nav = UINavigationController(rootViewController: vc)
             nav.modalPresentationStyle = .fullScreen
             return nav
         }()

}
extension UserExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerActionSheet() {
           let ac = UIAlertController(title: "Choose your experience type", message: nil, preferredStyle: .actionSheet)
           let firstAction = UIAlertAction(title: "Choose Photo from Library", style: .default) { (action) in
               self.showImagePickerController(sourceType: .photoLibrary)
           }
           let secondAction = UIAlertAction(title: "Take new photo", style: .default) { (action) in
               self.showImagePickerController(sourceType: .camera)
           }
        let videoAction = UIAlertAction(title: "Video Recording", style: .default) { (action) in
            self.requestPermissionAndShowCamera()
        }
           let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
           ac.addAction(firstAction)
           ac.addAction(secondAction)
            ac.addAction(videoAction)
           ac.addAction(cancelAction)
           present(ac, animated: true, completion: nil)
       }
       
       
       
       func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.allowsEditing = true
           imagePickerController.sourceType = sourceType
           present(imagePickerController, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
               imageView.image = editedImage
            self.originalImage = editedImage
          } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           imageView.image = originalImage
            self.originalImage = originalImage
           }
           dismiss(animated: true, completion: nil)
       }
   
    func requestPermissionAndShowCamera()  {
           let status = AVCaptureDevice.authorizationStatus(for: .video)
           
           switch status {
               case .notDetermined:
                   requestPermission()
               case .restricted:
                   fatalError("You don't have permission to use the camera, talk to your parent about enabling")
               case .denied:
                   fatalError("Show them a link to settings to get access to video")
               case .authorized: //2nd + run, they've given permission to use the camera
            present(videoRecordingViewController, animated: true, completion: nil)
                   break
               @unknown default:
                   fatalError("Didn't ")
           }
           
       }
       
        func requestPermission() {
           AVCaptureDevice.requestAccess(for: .video) { granted in
               guard granted else { fatalError("Tell user they need to get video permission") }
               DispatchQueue.main.async {
                   //
                   self.present(self.videoRecordingViewController, animated: true, completion: nil)
               }
           }
       }
}
