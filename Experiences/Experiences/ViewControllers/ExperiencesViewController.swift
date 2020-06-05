//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Bhawnish Kumar on 6/5/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ExperiencesViewController: UIViewController {
    
    // MARK: - Properites
    var experienceController: ExperienceController?
    var delegate: MapViewController?
    private var inited = false
    
    private var audioClip: URL?
    private var audioRecorder: AVAudioRecorder?
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            
            audioPlayer?.delegate = self
        }
    }
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    private var videoClip: URL?
    private var player: AVPlayer!
    let context = CIContext(options: nil)
    
    var originalImage: UIImage? {
           didSet {
               // resize the scaledImage and set it view
               guard let originalImage = originalImage else { return }
               // Height and width
               var scaledSize = imageView.bounds.size
               let scale = UIScreen.main.scale  // Size of pixels on this device: 1x, 2x, or 3x
               scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
               scaledImage = originalImage.imageByScaling(toSize: scaledSize)
           }
       }
    
    var scaledImage: UIImage? 
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
