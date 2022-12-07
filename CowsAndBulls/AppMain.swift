//
//  AppMain.swift
//  CowsAndBulls
//
//  Created by Zaid Neurothrone on 2022-11-05.
//

import SwiftUI

@main
struct AppMain: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .windowResizability(.contentSize)
    
    Settings(content: SettingsView.init)
  }
}
