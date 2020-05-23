//
//  ContentView.swift
//  Experiences
//
//  Created by Alex Shillingford on 5/17/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var data: ExperienceData
    @State var addButtonIsTapped = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<data.experiences.count) { experience in
                    NavigationLink(
                        destination: ExperienceView(experience: self.data.experiences[experience])
                    ) {
                        ExperienceRow(
                            experience: self.data.experienceNames[experience]
                        )
                    }
                }
            }
            .sheet(isPresented: $addButtonIsTapped, onDismiss: resetAddButtonBool, content: {
                AddExperienceView()
            })
            .navigationBarTitle("Experiences")
            .navigationBarItems(trailing:
                Button(action: {
                    self.addButtonIsTapped.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                })
            )
        }
    }
    
    func resetAddButtonBool() {
        addButtonIsTapped = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(data: ExperienceData())
    }
}

let screen = UIScreen.main.bounds
