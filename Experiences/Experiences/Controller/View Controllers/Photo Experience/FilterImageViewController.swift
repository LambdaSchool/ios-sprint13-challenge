//
//  FilterImageViewController.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class FilterImageViewController: UIViewController {
    // MARK: - Properties -
    lazy var photoController = PhotoController(delegate: self)

    @IBOutlet weak var photoFilterImageView: UIImageView!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var propertyStackView1: UIStackView!
    @IBOutlet weak var propertyStackView2: UIStackView!
    @IBOutlet weak var propertyStackView3: UIStackView!
    @IBOutlet weak var sliderLabel1: UILabel!
    @IBOutlet weak var sliderLabel2: UILabel!
    @IBOutlet weak var sliderLabel3: UILabel!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!


    override func viewDidLoad() {
        super.viewDidLoad()
        photoController.setImage(image: .sampleImage)
        setupFilterUI(.gaussian)
    }

    private func updateFilter() {
        switch filterSelector.selectedSegmentIndex {
        case 0:
            photoController.blurFilter(radius: slider1.value)
        case 1:
            photoController.bloomFilter(intensity: slider1.value, radius: slider2.value)
        case 2:
            print("Todo")
        case 3:
            print("Todo")
        default:
            print("Selection number \(filterSelector.selectedSegmentIndex) not implemented")
            break
        }
    }

    private func setupFilterUI(_ filter: Filter) {
        switch filter {
        case .gaussian:
            blurFilterUI()
        case .bloom:
            bloomFilterUI()
        default:
            print("todo")
        }
        updateFilter()
    }

    private func blurFilterUI() {
        propertyStackView1.isHidden = false
        sliderLabel1.text = "Radius"
        slider1.isHidden = false
        slider1.minimumValue = 0
        slider1.maximumValue = 10
        slider1.value = 5
        propertyStackView2.isHidden = true
        propertyStackView3.isHidden = true
    }

    private func bloomFilterUI() {
        //radius
        propertyStackView1.isHidden = false
        sliderLabel1.text = "Radius"
        slider1.minimumValue = 0
        slider1.maximumValue = 1
        slider1.value = 0.5
        //intensity
        propertyStackView2.isHidden = false
        sliderLabel2.text = "Intensity"
        slider2.minimumValue = 0
        slider2.maximumValue = 20
        slider2.value = 10

        propertyStackView3.isHidden = true
    }

    @IBAction func filterSelectorDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setupFilterUI(.gaussian)
        case 1:
            setupFilterUI(.bloom)
        default:
            print("setup this UI")
        }

    }

    @IBAction func slider1DidChange(_ sender: UISlider) {
        updateFilter()
    }

    @IBAction func slider2DidChange(_ sender: UISlider) {
        updateFilter()
    }

    @IBAction func slider3DidChange(_ sender: UISlider) {
        updateFilter()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}

extension FilterImageViewController: PhotoUIDelegate {

}


