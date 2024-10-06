//
//  ResetApp.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-05.
//

import SwiftUI

@main
struct ResetApp: App {

  var body: some Scene {
    WindowGroup {
      ContentView()
        .modelContainer(for: Reset.self)
    }
  }
}
