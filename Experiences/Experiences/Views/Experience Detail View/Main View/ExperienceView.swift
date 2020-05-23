//
//  ExperienceView.swift
//  Experiences
//
//  Created by Alex Shillingford on 5/17/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import SwiftUI
import MapKit

struct ExperienceView: View {
    var experience: Experience
    
    var body: some View {
        ZStack {
                VStack {
                    VStack {
                        MapView(latitude: experience.latitude ?? 37.3230, longitude: experience.longitude ?? 122.0322)
                            .frame(width: screen.width, height: screen.height / 2.5)
                        
                        CircleImage(image: Image(uiImage: experience.photo ?? UIImage(systemName: "person.circle")!))
                            .offset(y: -(screen.height / 6))
                        
                        HStack {
                            Text(experience.title)
                                .font(.title)
                                .bold()
                                .padding()
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            .edgesIgnoringSafeArea(.top)
        }
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
