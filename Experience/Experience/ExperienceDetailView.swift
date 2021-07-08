//
//  ExperienceDetailView.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class ExperienceDetailView: UIView
{
    private let locationLabel = UILabel()
    var experience: Experience?
    {
        didSet
        {
            updateSubviews()
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let locationLabel = UILabel()
        addSubview(locationLabel)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError()
    }
    
    private func updateSubviews()
    {
        guard let experience = experience else {return}
        locationLabel.text = experience.experienceTitle
        
    }
}
