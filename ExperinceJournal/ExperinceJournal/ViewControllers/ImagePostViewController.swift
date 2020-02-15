//
//  ImagePostViewController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit
import Photos

protocol ImageViewControllerDelegate {
    func imagePostButtonWasTapped()
}

class ImagePostViewController: UIViewController {
    
    var entryController = EntryController()
    var imageData: Data?
    var delegate: ImageViewControllerDelegate?
    private var blackAndWhiteFilter = CIFilter(name: "CIPhotoEffectNoir")
    private var context = CIContext(options: nil)
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var GeoTag: UISwitch!
    @IBOutlet weak var choseImageButton: UIButton!
    @IBOutlet weak var postImageButton: UIBarButtonItem!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
