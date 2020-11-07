//
//  DetailVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import MapKit

class DetailVC: UIViewController {

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var audioButton: UIButton!
    @IBOutlet private var videoButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var mapView: MKMapView!
    
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
    @IBAction func playAudio(_ sender: UIButton) {
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
    }
}
