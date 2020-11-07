//
//  VideoRecorderViewController.swift
//  Experiences
//
//  Created by Rob Vance on 11/6/20.
//

import UIKit

class VideoRecorderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBOutlets -
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - IBActions -
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
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
