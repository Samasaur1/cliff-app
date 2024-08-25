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
    @State var authorizationStatus: UNAuthorizationStatus? = nil
    
    var body: some View {
        VStack {
            TextField("Server Base URL", text: $serverURL)
            Button {
                let url = URL(string: serverURL)
                UserDefaults.standard.set(url, forKey: "server")
                
                Task {
                    // Register for notifications
                    let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay])
                    print("Permission granted: \(granted)")
                    #if os(macOS)
                    NSApplication.shared.registerForRemoteNotifications()
                    #else
                    UIApplication.shared.registerForRemoteNotifications()
                    #endif
                    self.authorizationStatus = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
                }
            } label: {
                Text("Register for notifications")
            }
            HStack {
                Text("Current status:")
                switch authorizationStatus {
                case .notDetermined:
                    Image(systemName: "questionmark")
                case .denied:
                    Image(systemName: "xmark")
                case .authorized:
                    Image(systemName: "checkmark")
                case .provisional:
                    Text("provisional")
                case .ephemeral:
                    Text("ephemeral")
                case nil:
                    ProgressView()
                @unknown default:
                    Text("New case")
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                self.authorizationStatus = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
            }
        }
    }
}

#Preview {
    ContentView()
}
