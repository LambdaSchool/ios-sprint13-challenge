//
//  AddVideoViewController.swift
//  ExperiencesWorkingDraft
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import AVFoundation
//TODO: Set Up video permissions here
//TODO: Record and save video with immediate playback in a smaller window.
//TODO: connect buttons so when user hits save or cancel buttons the view controller dismisses with or without the delegate function properly and sends on the data to the controller
class AddVideoViewController: UIViewController {
    //MARK: - Properties -
    var videoDelegate: VideoAdderDelegate?
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
}
