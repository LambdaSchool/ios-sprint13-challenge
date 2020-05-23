//
//  AudioRecorderView.swift
//  Experiences
//
//  Created by Alex Shillingford on 5/20/20.
//  Copyright © 2020 shillwil. All rights reserved.
//
import Foundation
import SwiftUI
import Combine
import AVFoundation

struct AudioRecorderView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var audioURL: URL?
    
    var body: some View {
        VStack {
            if audioRecorder.recording == false {
                Button(action: {
                    self.audioRecorder.startRecording()
                    self.audioURL = self.audioRecorder.recordingURL
                }) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            } else {
                Button(action: {
                    self.audioRecorder.stopRecording()
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

struct AudioRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecorderView(audioRecorder: AudioRecorder(), audioURL: .constant(nil))
    }
}
