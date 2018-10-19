//
//  VideoPlaybackViewController.swift
//  Memories
//
//  Created by Samantha Gatt on 10/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class VideoPlaybackViewController: UIViewController {
    
    // MARK: - Properties
    
    var titleString: String?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    
    
    // MARK: - Private Properties
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var videoView: UIView!
    
    
    // MARK: - Actions
    
    @IBAction func saveMemory(_ sender: Any) {
        
    }
}
