//
//  SettingsView.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/23/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserSettings()

    
//    @State var receive = false
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
        self.setNotification()

    }
    
    var body: some View {
        
        NavigationView {
            Form {
                // Notifications Section
                Section(header: Text("Notifcations")) {
                    Toggle(isOn: $userSettings.recieveNotifications) {
                        Text("Receive Notifications")
                    }
                    .toggleStyle(ColoredToggleStyle())
//
//                    Stepper(value: $number, in: 1...8) {
//                        Text("\(number) Notification\(number > 1 ? "s" : "") per day")
//                    }.disabled(!userSettings.recieveNotifications)
//
//                    DatePicker(selection: $date, displayedComponents: .hourAndMinute) {
//                        Text("Start notifications at")
//                    }.disabled(!userSettings.recieveNotifications)
                    
                }.listRowBackground(Color.init(UIColor.ravenClawBlue).opacity(0.9))
                    .foregroundColor(Color.init(UIColor.undeadWhite))
                
                // App Settings Section
                Section(header: Text("App Settings")) {
                    Toggle(isOn: $userSettings.enableAppSounds) {
                        Text("In App Sounds")
                    }
                    .toggleStyle(ColoredToggleStyle())
                    
                    Toggle(isOn: $userSettings.enableHapticFeedback) {
                        Text("Haptic Feedback")
                    }
                    .toggleStyle(ColoredToggleStyle())
                    
                    Toggle(isOn: $userSettings.addToHealthApp) {
                        Text("Add to Health App")
                    }.toggleStyle(ColoredToggleStyle())
                }
                .listRowBackground(Color.init(UIColor.ravenClawBlue).opacity(0.9))
                .foregroundColor(Color.init(UIColor.undeadWhite))
                
                //About Section
                Section(header: Text("About")) {
                    Button(action: {
                        if let url = URL(string: "https://github.com/LambdaSchool/ios-pt4-bw4-david-joshua-sal/issues") {
                            UIApplication.shared.open(url) }
                    }) {
                        Text("Report an issue")
                    }
                    Button(action: {
                        if let url = URL(string: "https://google.com") { UIApplication.shared.open(url) }
                    }) {
                        Text("Rate the app")
                    }
                    NavigationLink(destination: SecondContentView()) {
                        Text("About Us")
                    }
                }.listRowBackground(Color.init(UIColor.ravenClawBlue).opacity(0.9))
                    .foregroundColor(Color.init(UIColor.undeadWhite))
            }
            .navigationBarTitle("Settings")
            
        }
    }
    
    
    func setNotification() -> Void {
        let manager = LocalNotificationManager()
        manager.requestPermission()
        manager.addNotification(title: "This is a test reminder")
        manager.scheduleNotifications()
    }
}

struct SecondContentView: View {
    var body: some View {
        Text("Coming Soon!")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color(UIColor.sicklySmurfBlue)
    var offColor = Color(UIColor.ravenClawBlue)
    var thumbColor = Color(UIColor.undeadWhite)
    
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
