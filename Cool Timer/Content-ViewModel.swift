//
//  Content-ViewModel.swift
//  Cool Timer
//
//  Created by Ioannis Andreoulakis on 12/7/23.
//

import Foundation

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var isActive = false // determines whether our timer is being used or not
        @Published var showingAlert = false // tells us whether we are showing an alert or not
        @Published var time: String = "60:00" // displayed time
        @Published var minutes: Float = 10.0 { // the user's selected minutes, of type float for slider
            didSet {                            // everytime this does get set
                self.time = "\(Int(minutes)):00"
            }
        }
        
        private var initialTime = 0
        private var endDate = Date() // these are going to be updated to keep track of the current time of our app
        
        func start(minutes: Float) {
            self.initialTime = Int(minutes)
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
        }
        
        func rest() {               // reseting the app to the initial state
            self.minutes = Float(initialTime)
            self.isActive = false
            self.time = "\(Int(minutes)):00"
        }
        
        func updateCountdown() {
            guard isActive else { return }  // if active is set to true or else we dont rly have to update anything so we return out of it
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970 // thats the difference calculated, thats the remaining                                                                   //time between now and the date we selected
            if diff <= 0 {
                self.isActive = false
                self.time = "0:00"
                self.showingAlert = true
                return
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)   // these are the components
            let seconds = calendar.component(.second, from: date)   // to create our String to let the user know

            self.minutes = Float(minutes)     // this will allows us to keep track of the remaining minutes so we create the countdown slider and actively show the user that the slider is getting smaller
            self.time = String(format: "%d:%02d", minutes, seconds)
            
        }
        
    }
}
