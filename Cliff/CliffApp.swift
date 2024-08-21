//
//  CliffApp.swift
//  Cliff
//
//  Created by Sam Gauck on 8/18/24.
//

import SwiftUI

@main
struct CliffApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    #else
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
