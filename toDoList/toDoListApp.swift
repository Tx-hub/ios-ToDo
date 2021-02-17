//
//  toDoListApp.swift
//  toDoList
//
//  Created by tuxiao on 2021/2/16.
//

import SwiftUI
import UserNotifications



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            //3
            print("Permission granted: \(granted)")
    }
        return true
    }
}

@main
struct toDoListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
