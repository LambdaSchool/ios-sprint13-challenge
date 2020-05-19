//
//  AddExperienceView.swift
//  Experiences
//
//  Created by Alex Shillingford on 5/17/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import SwiftUI

struct AddExperienceView: View {
    @State var experienceTitleText: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter a title...", text: $experienceTitleText)
                .frame(height: 30)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1))
                .padding(.horizontal, 8)
            
            
            
            ScrollView {
                AddPhotoCellView()
                
                AddAudioCellView()
                
                AddVideoCellView()
                
                AddLocationCellView()
            }
            Spacer()
            
            DoneButtonView()
        }
    }
}

struct AddExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        AddExperienceView()
    }
}

struct DoneButtonView: View {
    var body: some View {
        HStack {
            HStack {
                Text("Post")
                    .font(.body)
                Image(systemName: "checkmark")
            }
            .frame(width: screen.width - 40, height: screen.width / 8)
            .background(Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)))
            Spacer()
            
        }
        .foregroundColor(.white)
        .frame(width: screen.width - 40, height: screen.width / 8)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .background(Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)))
        .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).stroke(Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), lineWidth: 4))
        .shadow(color: .black, radius: 1, x: 0, y: 3)
    .padding()
    }
}
