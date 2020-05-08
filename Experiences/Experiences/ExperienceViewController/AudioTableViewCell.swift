//
//  AudioTableViewCell.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell {
    
    var url: URL?
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timelineSlider: UISlider!

    @IBAction func togglePlayback(_ sender: Any) {
    }
}
