//
//  AppDelegate.swift
//  Cliff
//
//  Created by Sam Gauck on 8/20/24.
//

import Foundation

class AppDelegate: NSObject {
    func sendDeviceTokenToServer(_ token: Data) {
        let tokenString = token.map { String(format: "%.2x", $0) }.joined()
        
        guard let serverURL = UserDefaults.standard.url(forKey: "server") else {
            print("Missing server base URL in UserDefaults")
            return
        }
        
        Task {
            var req = URLRequest(url: serverURL.appending(path: "register"))
            req.httpBody = tokenString.data(using: .utf8)
            req.httpMethod = "POST"
            
            do {
                let (data, response) = try await URLSession.shared.data(for: req)
                guard let response = response as? HTTPURLResponse else { return }
                guard response.statusCode == 200 else {
                    print("non-200 status code on response to sending device token")
                    return
                }
            } catch {
                print("Error sending device token to server")
                print(error)
            }
        }
    }
}

#if os(macOS)
import AppKit
extension AppDelegate: NSApplicationDelegate {
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        sendDeviceTokenToServer(deviceToken)
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register for remote notifications")
        print(error)
    }
}
#else
import UIKit
extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        sendDeviceTokenToServer(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register for remote notifications")
        print(error)
    }
}
#endif