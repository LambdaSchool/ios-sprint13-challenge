//
//  PhotoUIDelegate.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
import UIKit

protocol PhotoUIDelegate: AVCapturePhotoCaptureDelegate {
    var photoFilterImageView: UIImageView! { get set }
    func updatePhoto(_ with: CGImage)
}

extension PhotoUIDelegate {
    func updatePhoto(_ with: CGImage) {
        DispatchQueue.main.async {
            self.photoFilterImageView.image = UIImage(cgImage: with)
        }
    }
}
