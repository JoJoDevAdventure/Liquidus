//
//  Liquidus_App.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//
//  String Extension by Paul Hudson
//  https://www.hackingwithswift.com/example-code/strings/how-to-read-a-single-character-from-a-string
//

import SwiftUI

@main
struct Liquidus_App: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(DrinkModel(test: false, suiteName: nil))
        }
    }
}
