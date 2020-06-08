//
//  VideoViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoDelegate {
    func videoButtonTapped()
}

class VideoViewController: UIViewController {
    
    //MARK: Properties -
    
    lazy private var captureSession = AVCaptureSession()
       lazy private var fileOutput = AVCaptureMovieFileOutput()
       var player: AVPlayer?
       var postController: PostController?
       var delegate: VideoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
