//
//  PinDetailsView.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class PinDetailsView: UIView {

	// MARK: - IBOutlets
	
	@IBOutlet weak var captionLbl: UILabel!
	@IBOutlet weak var dateLbl: UILabel!
	@IBOutlet weak var mediaBtn: UIButton!
	
	// MARK: - Properties
	
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
	var experience: Experience? {
		didSet {
			updateSubviews()
		}
	}
	
	// MARK: - IBActions
	
	@IBAction func mediaBtnTapped(_ sender: Any) {
		print("Switching to media")
	}
	
	// MARK: - Helpers
	
    private func updateSubviews() {
//        guard let experience = experience else { return }
		
		if let experience = experience {
			captionLbl.text = experience.caption
			dateLbl.text = dateFormatter.string(from: experience.timestamp)
			
			if experience.audioUrl != nil {
				let image = UIImage(systemName: "ear")
				mediaBtn.setImage(image, for: .normal)
			} else if experience.videoUrl != nil {
				let image = UIImage(systemName: "video")
				mediaBtn.setImage(image, for: .normal)
			} else {
				let image = UIImage(systemName: "xmark.icloud.fill")
				mediaBtn.setImage(image, for: .normal)
			}
		} else {
			captionLbl.isHidden = true
			dateLbl.isHidden = true
			mediaBtn.setImage(nil, for: .normal)
			mediaBtn.setTitle("Add Experience", for: .normal)
		}
    }
}
