//
//  ExperienceViewCell.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import UIKit

class ExperienceViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var experience: Experience? {
        didSet {
            update()
        }
    }
    
    // MARK: - Interface Builder
    
    @IBOutlet var experienceImage: UIImageView!
    @IBOutlet var title: UILabel!
    
    // MARK: - Utility
    private func update() {
        if let experience = experience {
            title.text = experience.title
        }
        
        if let imageData = experience?.image {
            experienceImage.image = UIImage(data: imageData)
        }
    }
    
}
