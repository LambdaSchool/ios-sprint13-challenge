//
//  AudioPlayer.swift
//  Experiences
//
//  Created by Alex Shillingford on 5/17/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import SwiftUI
import AVFoundation

struct AudioPlayer: View {
    @Binding var sliderValue: Double
    var player: AVAudioPlayer?
    var audioURL: URL?
    
    var body: some View {
        VStack {
            HStack {
                Text("0:00")
                Slider(value: $sliderValue)
                Text("0:00")
            }
            
            HStack {
                Button(action: {
                    self.player?.play()
                }) {
                    Image(systemName: "play.fill")
                }
                
                Spacer()
                
                Button(action: {
                    self.player?.pause()
                }) {
                    Image(systemName: "pause.fill")
                }
            }
        }
        .frame(height: screen.width / 3)
        .padding(.horizontal)
    }
    
    mutating func loadAudio() {
        guard let audioURL = audioURL else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
        } catch {
            preconditionFailure("Failure to load audio")
        }
    }
}

struct AudioPlayer_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) { deviceName in
            AudioPlayer(sliderValue: .constant(0.5))
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
