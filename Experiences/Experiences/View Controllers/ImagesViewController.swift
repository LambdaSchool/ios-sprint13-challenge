//
//  ImagesViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ImagesViewController: UIViewController {
  
  var experienceController: ExperienceController?
  let locationManager = CLLocationManager()
  var experienceNoteTitle2 = ""
  private let context = CIContext()
  private let colorControlsFilter = CIFilter.colorControls()
  private let blurFilter = CIFilter.gaussianBlur()
  
  //MARK: Outlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleFromMain: UILabel!
  @IBOutlet weak var brightnessSlider: UISlider!
  @IBOutlet weak var contrastSlider: UISlider!
  @IBOutlet weak var saturationSlider: UISlider!
  @IBOutlet weak var blurSlider: UISlider!
  @IBOutlet weak var mysterySlider: UISlider!
  
  

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
  //MARK: Actions
  
  @IBAction func brightnessSliderTap(_ sender: Any) {
  }
  @IBAction func contrastSliderTap(_ sender: Any) {
  }
  @IBAction func saturationSliderTap(_ sender: Any) {
  }
  @IBAction func blurSliderTap(_ sender: Any) {
  }
  @IBAction func mysterySliderTap(_ sender: Any) {
  }
  @IBAction func saveBtnPressed(_ sender: Any) {
  }
  @IBAction func nextBtnTapped(_ sender: UIBarButtonItem) {
  }
  @IBAction func selectImageTapped(_ sender: Any) {
  }
  @IBAction func selectCameraTapped(_ sender: Any) {
  }
  
  
  

}
