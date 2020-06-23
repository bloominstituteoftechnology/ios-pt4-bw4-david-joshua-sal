//
//  SettingsView.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/23/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    
    @State var receive = false
    @State var sounds = true
    @State var haptic = true
    @State var health = false
    @State var number = 1
    @State var selection = 1
    @State var date = Date() // Fix to default 0600
    
    init() {
        UITableView.appearance().backgroundColor = .ravenClawBlue // Uses UIColor
        
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.undeadWhite]
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                // Notifications Section
                Section(header: Text("Notifcations")) {
                    Toggle(isOn: $receive) {
                        Text("Receive Notifications")
                    }
                    .toggleStyle(ColoredToggleStyle())
                    Stepper(value: $number, in: 1...8) {
                        Text("\(number) Notification\(number > 1 ? "s" : "") per day")
                    }.disabled(!receive)
                    DatePicker(selection: $date, displayedComponents: .hourAndMinute) {
                        Text("Start notifications at")
                    }.disabled(!receive)
                }.listRowBackground(Color.init(UIColor.ravenClawBlue).opacity(0.9))
                    .foregroundColor(Color.init(UIColor.undeadWhite))
                
                // App Settings Section
                Section(header: Text("App Settings")) {
                    Toggle(isOn: $sounds) {
                        Text("In App Sounds")
                    }.toggleStyle(ColoredToggleStyle())
                    Toggle(isOn: $haptic) {
                        Text("Haptic Feedback")
                    }.toggleStyle(ColoredToggleStyle())
                    Toggle(isOn: $health) {
                        Text("Add to Health App")
                    }.toggleStyle(ColoredToggleStyle())
                }.listRowBackground(Color.init(UIColor.ravenClawBlue).opacity(0.9))
                    .foregroundColor(Color.init(UIColor.undeadWhite))
            }
            .navigationBarTitle("Settings")

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color(UIColor.sicklySmurfBlue)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label // The text (or view) portion of the Toggle
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 29)
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(Animation.easeInOut(duration: 0.2))
                .onTapGesture { configuration.isOn.toggle() }
        }
        .font(.body)
    }
}
