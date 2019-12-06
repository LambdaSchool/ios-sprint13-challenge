//
//  CameraViewController.swift
//  Experiences
//
//  Created by Jesse Ruiz on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    var playerLayer: AVPlayerLayer!
    var player: AVQueuePlayer!
    var playerLooper: AVPlayerLooper!
    var currentVideoURL: URL?
    
    // MARK: - Outlets
    @IBOutlet weak var recordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func record(_ sender: UIButton) {
        
    }
    
    @IBAction func saveRecording(_ sender: UIBarButtonItem) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Methods


}
