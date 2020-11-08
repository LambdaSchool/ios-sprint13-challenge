//
//  AudioRecorderViewController.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import AVFoundation
import MapKit

class AudioRecorderViewController: UIViewController {
    
  //  @IBOutlet weak var audioVisualizer: AudioVisualizer!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    
    
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
