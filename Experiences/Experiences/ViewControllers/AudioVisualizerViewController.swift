//
//  AudioVisualizerViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class AudioVisualizerViewController: UIViewController {

    @IBOutlet weak var visualizer: AudioVisualizer!
    
    func updateVisualizer(withAmplitude decibels: Float) {
        guard isViewLoaded else { return }
        visualizer.addValue(decibelValue: decibels)
    }
}
