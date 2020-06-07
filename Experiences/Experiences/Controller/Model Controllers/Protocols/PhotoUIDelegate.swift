//
//  PhotoUIDelegate.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
import UIKit

protocol PhotoUIDelegate: AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate {
    var photoFilterImageView: UIImageView! { get set }
    func updatePhoto(_ with: CGImage)
    func presentImagePickerController()
}

extension PhotoUIDelegate {
    func updatePhoto(_ with: CGImage) {
        DispatchQueue.main.async {
            self.photoFilterImageView.image = UIImage(cgImage: with)
        }
    }

    func presentImagePickerController() {
        
    }
}
