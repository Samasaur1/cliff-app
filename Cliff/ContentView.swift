//
//  ContentView.swift
//  Cliff
//
//  Created by Sam Gauck on 8/18/24.
//

import Foundation
import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var serverURL: String = ""
    
    var body: some View {
        VStack {
            TextField("Server Base URL", text: $serverURL)
            Button {
                let url = URL(string: serverURL)
                UserDefaults.standard.set(url, forKey: "server")
                // register for notifications
                UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound, .carPlay, .criticalAlert]) { granted, error in
                        print("Permission granted: \(granted)")
                    }
                #if os(macOS)
                NSApplication.shared.registerForRemoteNotifications()
                #else
                UIApplication.shared.registerForRemoteNotifications()
                #endif
            } label: {
                Text("Register for notifications")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
