//
//  ExperienceView.swift
//  Experiences
//
//  Created by Alex Shillingford on 5/17/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import SwiftUI

struct ExperienceView: View {
    var experience: Experience
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) { deviceName in
            ExperienceView(experience: Experience(title: "Test New Experience", photo: nil, audioURL: nil, videoURL: nil, latitude: nil, longitude: nil))
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
