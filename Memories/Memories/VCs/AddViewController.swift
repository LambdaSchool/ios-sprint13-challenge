//
//  AddViewController.swift
//  Test
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import MapKit
import CoreImage.CIFilterBuiltins

class AddViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    var titleText: String?
    var image: Data?
    var originalImage: Data?
    var audio: String? { UserDefaults.standard.string(forKey: "CurrentAudio") }
    var video: String? { UserDefaults.standard.string(forKey: "CurrentVideo") }
    
    var picker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var coordinates: CLLocationCoordinate2D? { didSet { finishSaving() }}
    private let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        UserDefaults.standard.removeObject(forKey: "CurrentAudio")
        UserDefaults.standard.removeObject(forKey: "CurrentVideo")
    }
    
    @IBAction func textFieldReturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func addImage(_ sender: Any) {
        picker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: { (sction: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil) }
            else { print("Camera not available") } }))
        actionSheet.addAction(UIAlertAction(title: "Photo Libary", style: .default , handler: { (sction: UIAlertAction) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func filterImage(_ sender: Any) {
        filterButton.isSelected.toggle()
        if filterButton.isSelected {
        guard let image = originalImage else { return }
        var ciImage = CIImage(data: image)
        let filter = CIFilter.colorMonochrome()
        filter.inputImage = ciImage
        filter.color = CIColor(color: .black)
        ciImage = filter.outputImage
        guard let outputCI = ciImage else { return }
        guard let outputCG = context.createCGImage(outputCI, from: CGRect(origin: CGPoint.zero, size: imageView.image!.size)) else { return }
        let uiImage = UIImage(cgImage: outputCG)
        imageView.image = uiImage
            self.image = uiImage.pngData()
        }
        else {
            imageView.image = UIImage(data: originalImage!)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        save()
    }
    
    private func save() {
        //Check for title
        guard let title = titleField.text, !(titleField.text?.isEmpty ?? true) else { Helper.alert(on: self, "Please add a title", "You can't save this without one"); return }
        titleText = title
        //Get location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else {
            Helper.alert(on: self, "Please turn on access for your location", "We are unable to display this data to you otherwise"); return }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func finishSaving() {
        guard let coordinates = coordinates else { return }
        var memories = Helper.getMemories()
        let image = filterButton.isSelected ? self.image : originalImage
        memories.append(Memory(title: titleText!, image: image, videoURL: video, audioURL: audio, latitude: coordinates.latitude, longitude: coordinates.longitude))
        print(memories)
        Helper.setMemories(memories)
        NotificationCenter.default.post(name: NSNotification.Name("NewMemory"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Audio & Video
    @IBAction func addAudio(_ sender: Any) {
        audioButton.isSelected.toggle()
        hideAudio(!audioButton.isSelected)
        hideVideo(audioButton.isSelected)
    }
    
    @IBAction func addVideo(_ sender: Any) {
        videoButton.isSelected.toggle()
        hideAudio(videoButton.isSelected)
        hideVideo(!videoButton.isSelected)
    }
    
    private func hideAudio(_ bool: Bool) {
        audioButton.isSelected = !bool
        audioView.isHidden = bool
    }
    
    private func hideVideo(_ bool: Bool) {
        videoButton.isSelected = !bool
        videoView.isHidden = bool
    }
    
    //MARK: - LocationDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        self.coordinates = location
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        imageButton.isHidden = true
        self.image = image.pngData()
        self.originalImage = image.pngData()
        imageView.image = image
        filterButton.isHidden = false
    }
}

