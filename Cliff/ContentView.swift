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
    @AppStorage("server") var serverURL: String = ""
    @State var notificationSettings: UNNotificationSettings? = nil
    @State var granted: Bool? = nil
    @EnvironmentObject private var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            Label("Server base URL", systemImage: "star").labelStyle(.titleOnly).font(.caption.smallCaps())
            // This URL has a zero-width joiner between the `:` and the `/` so that SwiftUI doesn't color it blue.
            // The way that you normally would prevent this behavior is with the `.tint` modifier, but the `prompt`
            // parameter must be of type `Text`
            TextField("Server base URL", text: $serverURL, prompt: Text("http:​​//cliff.wholphin-wyvern.ts.net"))
                .textFieldStyle(.roundedBorder)
                .textContentType(.URL)
                .autocorrectionDisabled()
            #if !os(macOS)
                .textInputAutocapitalization(.never)
            #endif
            Spacer()
                .frame(maxHeight: 15)
            Button {
                Task {
                    // Register for notifications
                    self.granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay])
                    print("Permission granted: \(granted!)")
                    #if os(macOS)
                    NSApplication.shared.registerForRemoteNotifications()
                    #else
                    UIApplication.shared.registerForRemoteNotifications()
                    #endif
                    self.notificationSettings = await UNUserNotificationCenter.current().notificationSettings()
                }
            } label: {
                Text("Register for notifications")
            }
            .buttonStyle(.borderedProminent)
            Divider()
            Text("status")
                .font(.title.smallCaps())
            VStack(alignment: .leading) {
                HStack {
                    Text("Notifications granted:")
                    switch self.granted {
                    case .some(true):
                        Image(systemName: "checkmark")
                    case .some(false):
                        Image(systemName: "xmark")
                    case nil:
                        Text("not requested during this interaction")
                            .font(.caption.italic())
                            .foregroundStyle(Color.secondary)
                    }
                }
                HStack {
                    Text("Notification permissions:")
                    switch self.notificationSettings?.authorizationStatus {
                    case .notDetermined:
                        Image(systemName: "questionmark")
                        Text("(not determined)")
                            .font(.caption)
                    case .denied:
                        Image(systemName: "xmark")
                        Text("(denied)")
                            .font(.caption)
                    case .authorized:
                        Image(systemName: "checkmark")
                        Text("(authorized)")
                            .font(.caption)
                    case .provisional:
                        Text("provisional")
                    case .ephemeral:
                        Text("ephemeral")
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown notification permission status")
                    }
                }
                HStack {
                    Text("- Alert permissions:")
                    switch self.notificationSettings?.alertSetting {
                    case .notSupported:
                        Image(systemName: "bell.badge.slash")
                        Text("(not supported)")
                            .font(.caption)
                    case .disabled:
                        Image(systemName: "xmark")
                        Text("(disabled)")
                            .font(.caption)
                    case .enabled:
                        Image(systemName: "checkmark")
                        Text("(enabled)")
                            .font(.caption)
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown alert permission status")
                    }
                }
                HStack {
                    Text("- Time sensitive permissions:")
                    switch self.notificationSettings?.timeSensitiveSetting {
                    case .notSupported:
                        Image(systemName: "bell.badge.slash")
                        Text("(not supported)")
                            .font(.caption)
                    case .disabled:
                        Image(systemName: "xmark")
                        Text("(disabled)")
                            .font(.caption)
                    case .enabled:
                        Image(systemName: "checkmark")
                        Text("(enabled)")
                            .font(.caption)
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown time sensitive permission status")
                    }
                }
                #if !os(macOS)
                HStack {
                    Text("- CarPlay permissions:")
                    switch self.notificationSettings?.carPlaySetting {
                    case .notSupported:
                        Image(systemName: "bell.badge.slash")
                        Text("(not supported)")
                            .font(.caption)
                    case .disabled:
                        Image(systemName: "xmark")
                        Text("(disabled)")
                            .font(.caption)
                    case .enabled:
                        Image(systemName: "checkmark")
                        Text("(enabled)")
                            .font(.caption)
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown carplay permission status")
                    }
                }
                #endif
                HStack {
                    Text("- Critical alert permissions:")
                    switch self.notificationSettings?.criticalAlertSetting {
                    case .notSupported:
                        Image(systemName: "bell.badge.slash")
                        Text("(not supported)")
                            .font(.caption)
                    case .disabled:
                        Image(systemName: "xmark")
                        Text("(disabled)")
                            .font(.caption)
                    case .enabled:
                        Image(systemName: "checkmark")
                        Text("(enabled)")
                            .font(.caption)
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown critical alert permission status")
                    }
                }
                HStack {
                    Text("- Lock Screen permissions:")
                    switch self.notificationSettings?.lockScreenSetting {
                    case .notSupported:
                        Image(systemName: "bell.badge.slash")
                        Text("(not supported)")
                            .font(.caption)
                    case .disabled:
                        Image(systemName: "xmark")
                        Text("(disabled)")
                            .font(.caption)
                    case .enabled:
                        Image(systemName: "checkmark")
                        Text("(enabled)")
                            .font(.caption)
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown lock screen permission status")
                    }
                }
                HStack {
                    Text("- Notification Center permissions:")
                    switch self.notificationSettings?.notificationCenterSetting {
                    case .notSupported:
                        Image(systemName: "bell.badge.slash")
                        Text("(not supported)")
                            .font(.caption)
                    case .disabled:
                        Image(systemName: "xmark")
                        Text("(disabled)")
                            .font(.caption)
                    case .enabled:
                        Image(systemName: "checkmark")
                        Text("(enabled)")
                            .font(.caption)
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown notification center permission status")
                    }
                }
                HStack {
                    Text("- Sound permissions:")
                    switch self.notificationSettings?.soundSetting {
                    case .notSupported:
                        Image(systemName: "bell.badge.slash")
                        Text("(not supported)")
                            .font(.caption)
                    case .disabled:
                        Image(systemName: "xmark")
                        Text("(disabled)")
                            .font(.caption)
                    case .enabled:
                        Image(systemName: "checkmark")
                        Text("(enabled)")
                            .font(.caption)
                    case nil:
                        ProgressView()
                    @unknown default:
                        Text("unknown sound permission status")
                    }
                }
                if let deviceToken = appDelegate.deviceToken {
                    HStack {
                        Text("APNs Token:")
                        switch deviceToken {
                        case .success(let success):
                            Text(success)
                        case .failure(let failure):
                            Text(failure.localizedDescription)
                        }
                    }
                }
                if let connectionSuccessful = appDelegate.connectionSuccessful {
                    HStack {
                        Text("Connection successful:")
                        switch connectionSuccessful {
                        case .success(let success):
                            Image(systemName: "checkmark")
                        case .failure(let failure):
                            Text(failure.localizedDescription)
                        }
                    }
                    switch connectionSuccessful {
                    case .success(let (data, response)):
                        if let response = response as? HTTPURLResponse {
                            HStack {
                                Text("Server response:")
                                switch response.statusCode {
                                case 200:
                                    Image(systemName: "checkmark")
                                default:
                                    Text(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
                                }
                            }
                            HStack {
                                Text("Response body:")
                                if let s = String(bytes: data, encoding: .utf8) {
                                    Text(s)
                                } else {
                                    Text("invalid UTF-8")
                                        .italic()
                                }
                            }
                        } else {
                            Text("Invalid server response (non-HTTPURLResponse)")
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                self.notificationSettings = await UNUserNotificationCenter.current().notificationSettings()
            }
        }
    }
}

#Preview {
    ContentView()
}
