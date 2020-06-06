//
//  JournalTableViewCell.swift
//  Experiences
//
//  Created by denis cedeno on 5/15/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    @IBOutlet weak var experienceTitle: UILabel!
        
        var experience: Experience? {
            didSet {
                updateViews()
            }
        }
        
        private func updateViews() {
            guard let experience  = experience else { return }
            experienceTitle.text = "   \(experience.title ?? "")"
            imageView!.image = UIImage(data: experience.image!)
        }
        
    }
