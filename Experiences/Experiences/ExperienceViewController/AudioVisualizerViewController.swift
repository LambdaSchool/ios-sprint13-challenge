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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateVisualizer(withAmplitude decibels: Float) {
        guard isViewLoaded else { return }
        visualizer.addValue(decibelValue: decibels)
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
