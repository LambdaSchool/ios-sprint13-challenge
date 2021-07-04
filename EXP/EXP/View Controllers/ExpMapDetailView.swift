//
//  ExpMapDetailView.swift
//  Exp
//
//  Created by Madison Waters on 2/23/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import UIKit

class ExpMapDetailView: UIView {
    
    private func updateSubViews() {
        guard let exp = exp else { return }
        
        let date = Date()
        dateLabel.text = dateFormatter.string(from: date)
        latitudeLabel.text = "Lat: " + latLonFormatter.string(from: exp.location.coordinate.latitude as NSNumber)!
        longitudeLabel.text = "Lon: " + latLonFormatter.string(from: exp.location.coordinate.longitude as NSNumber)!
    }
    
    var exp: Exp? {
        didSet {
            updateSubViews()
        }
    }
    
    private let dateLabel = UILabel()
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
    
    private lazy var latLonFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.minimumIntegerDigits = 1
        result.minimumFractionDigits = 2
        result.maximumFractionDigits = 2
        return result
    }()
    
}
